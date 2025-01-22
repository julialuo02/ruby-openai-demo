# Write your solution here!
require "openai"
require "http"
require "dotenv/load"

client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_KEY"))

LINE_WIDTH = 50
API_URL = "https://api.openai.com/v1/chat/completions"

def print_line
  puts "-" * LINE_WIDTH
end

def print_greeting
  puts "Hello! How can I help you today?"
  print_line
end

# Sends the conversation history to OpenAI's Chat Completions endpoint
def send_request(conversation_history)
  response = HTTP.post(
    API_URL,
    headers: {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV.fetch("OPENAI_KEY")}"
    },
    body: JSON.dump({
      model: "gpt-3.5-turbo", # Specify the model
      messages: conversation_history,
      max_tokens: 150
    })
  )
  JSON.parse(response.body.to_s)
end

conversation_history = [
  { role: "system", content: "You are a helpful assistant." } # System message for initial setup
]

print_greeting

loop do
  print "You: "
  user_input = gets.chomp

  if user_input.downcase == "bye"
    puts "Goodbye! Have a great day!"
    break
  end

  conversation_history << { role: "user", content: user_input }

  response_data = send_request(conversation_history)

  if response_data["choices"] && response_data["choices"].any?
    assistant_response = response_data["choices"][0]["message"]["content"]

    conversation_history << { role: "assistant", content: assistant_response }

    # Print the assistant's response
    print_line
    puts "Assistant: #{assistant_response}"
    print_line
  else
    puts "Something went wrong. Please try again."
  end
end
