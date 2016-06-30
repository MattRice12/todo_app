require_relative '../lib/todo'
require_relative '../lib/messages'

puts Messages::WELCOME

Todo.new.run
