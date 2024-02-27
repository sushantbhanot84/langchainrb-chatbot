# Chatbot APIs

This is a Ruby on Rails implementation for a RAG based Chatbot trained on custom documents(PDF).

## Ruby Version

This application requires Ruby version 3.0.6.

## Setup

1. Clone the repository:

    ```bash
    git clone https://github.com/sushantbhanot84/langchainrb-chatbot.git
    ```

2. Install dependencies:

    ```bash
    bundle install
    ```

3. Set up Chroma DB locally:

   - Follow instructions to install Chroma DB locally: [Chroma DB Installation Guide](https://github.com/chroma-core/chroma)

4. Run the following command to start Chroma:

    ```bash
    chroma run
    ```

5. Start the Rails server:

    ```bash
    rails server
    ```

## APIs

### Chatbots

- **Index**: `GET /api/v1/chatbots`
- **Show**: `GET /api/v1/chatbots/:name`
- **Create**: `POST /api/v1/chatbots`
  - Parameters: 
    - Name (string): Name of the chatbot.
    - PDF File (file): PDF file to be uploaded.
- **Destroy**: `DELETE /api/v1/chatbots/:name`

### Chat

- **Chat**: `POST /api/v1/chatbots/:name/chat`
  - Parameters:
    - question (string): question to send to the chatbot.

## Usage

1. Create a chatbot:
   - Send a `POST` request to `/api/v1/chatbots` with the chatbot's name and the PDF file in the form data.
  - Parameters:
    - name (string): Name of the chatbot.
    - pdf_doc (PDF File): PDF File you want your chatbot on.

2. Chat with the chatbot:
   - Send a `POST` request to `/api/v1/chatbots/:name/chat` with the chatbot's Name and the message in the request body.
  - Parameters:
    - question (string): question to send to the chatbot.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
