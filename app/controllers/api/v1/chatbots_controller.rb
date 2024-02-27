module Api::V1
  class ChatbotsController < ApplicationController
    def index
      chatbots = Chatbot.all.map{|chatbot| chatbot.name}
      render json: {chatbots: chatbots}
    end

    def show
    end

    def create
      puts(chatbot_params)
      if Chatbot.find_by(name: chatbot_params["name"]).present?
        return render json: {error: "Chatbot name is not unique"}, status: 400
      end
      chatbot = Chatbot.create(chatbot_params)
      if chatbot.valid?
        return render json: chatbot, status: 200
      else
        return render json: { errors: chatbot.errors.map{ |k,v| { title: chatbot.errors.full_message(k, v), meta: { attribute: k, message:  v } } } }, status: 400
      end
    end

    def update
    end

    def destroy
      if chatbot = Chatbot.find_by(name: params[:name])
        render json: {} and return if chatbot.destroy
        return render json: { errors: chatbot.errors.map{ |k,v| { title: chatbot.errors.full_message(k, v), meta: { attribute: k, message:  v } } } }, status: 400
      else
        render json: {error: "Chatbot not found"}, status: 400
      end
    end

    def chat
      if chatbot = Chatbot.find_by(name: params['name'])
        response = chatbot.chat(params['question'])
        return render json: { answer: response }
      else
        return render json: {error: "Invalid Chatbot"}, status: 404
      end
    end

    private

    def chatbot_params
      params.permit(:name, :pdf_doc)
    end

  end
end