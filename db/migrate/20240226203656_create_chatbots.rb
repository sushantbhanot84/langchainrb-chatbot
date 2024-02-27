class CreateChatbots < ActiveRecord::Migration[7.1]
  def change
    create_table :chatbots do |t|
      t.string :name
      t.string :chroma_collection

      t.timestamps
    end
  end
end
