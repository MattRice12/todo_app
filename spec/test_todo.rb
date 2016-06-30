equire 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/todo'
require_relative './spec_helper'

class TodoTest < MiniTest::Test
  def todo_setup
    $input  = [] # Reset all input between tests
    $output = [] # Reset all messages between tests
    @todo = Todo.new('spec/test_todos.csv') # Given
  end
end
