class Chatbot < ApplicationRecord
  attr_accessor :pdf_doc
  validates_presence_of :pdf_doc
  after_destroy :destroy_collection
  after_commit :create_embeddings, on: :create

  def chat(question)
    #using hypothetical document embedding
    search_results = chroma_client.similarity_search_with_hyde(query: question, k: 4)

    context = search_results.map do |result|
      result.document
    end

    context = context.join("\n---\n")

    prompt = generate_rag_prompt(question: question, context: context)
    messages = [{role: "user", content: prompt}]
    response = openai_llm.chat(messages: messages)

    response.context = context
    response.raw_response&.dig("choices")&.dig(0)&.dig("message")&.dig("content")
  end

  private

  def destroy_collection
    chroma_client.destroy_default_schema
  end

  def create_embeddings
    self.chroma_collection = unique_collection_name
    chroma_client.create_default_schema

    processor = Langchain::Processors::PDF.new
    pdf_content = processor.parse(File.new(pdf_doc))

    chunks = Langchain::Chunker::RecursiveText.new(
      pdf_content,
      chunk_size: 1000,
      chunk_overlap: 200
    )&.chunks

    chunks.each do |chunk|
      chroma_client.add_texts(texts: chunk.text)
    end
    self.save
  end

  def openai_llm
    llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_API_KEY'])
  end

  def unique_collection_name
    "#{name}_#{DateTime.now().to_i}_#{Random.rand(1000)}"
  end

  def chroma_client
    Langchain::Vectorsearch::Chroma.new(
      index_name: self.chroma_collection,
      llm: openai_llm,
      url: "http://localhost:8000"
    )
  end

  def generate_rag_prompt(question:, context:)
    prompt_template = Langchain::Prompt.load_from_path(
      file_path: Langchain.root.join("langchain/vectorsearch/prompts/rag.yaml")
    )
    prompt_template.format(question: question, context: context)
  end

end
