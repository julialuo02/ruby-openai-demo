# /env_test.rb
require "dotenv/load"

pp ENV.fetch("OPENAI_KEY")
