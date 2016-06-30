# TOOD App

# create program where users can add tasks
# allow user to "mark" complete tasks
# have incomplete tasks still be visible on the command line
  # e.g.,:
    # Complete Tasks:
    # Task 1
    # Task 2
    # Task 3
    # ______________
    # Incomplete Tasks:
    # Task 4
    # Task 5
    # Task 6

  # or:
    # [COMPLETE] Task #1
    # [INCOMPLETE] Task #2
    # [INCOMPLETE] Task #3
    # [COMPLETE] Task #4

# use CSVs? --> Yes

# require 'csv'

#1 Array of todos:
  # todo = [
    # { task: "a", complete?: "C" },
    # { task: "b", complete?: "I" },
  # ]

#1 Creation:
  # File.open("todo.txt", "w") do |file|
    # file << ["Task", "Complete/Incomplete"]
    # todo.each do |todo|
      # file << [todo[:task], todo[:complete?]]
    # end
  # end

#2 Iterate:
  # CSV.foreach("todo.csv") do |row|
    # puts row.inspect
  # end

#3 List:
  # CSV.foreach("accounts.csv", headers:true, header_converters: :symbol) do |row|
    # puts "#{row[:task]} [#{row[:complete?]}]"
  # end

#4 Task:
  # Input for Task

#3 Complete/Incomplete
  # Input (C/I) for whether task is complete or incomplete.


  require 'csv'

  class Todo
    attr_accessor :todo
    def initialize
      @todo = []
    end

    def welcome
      puts "Welcome to the task manager! You currently have the following tasks: "
    end

    def todo_list
      CSV.open("todo.csv", "w") do |csv|
        csv << ["Task", "Complete"]
        @todo.each do |todo|
          csv << [todo[:task], todo[:complete]]
        end
      end

      if @todo == []
        puts "\nYour list is empty!"
      else
        @todo #problem <--- this resets the array when the program is opened again. Need to set it to where it just pulls from todo.csv
      end
    end

    def run
      system("clear")
      @task_num = 1
      loop do
        welcome
        todo_list
        read_todo_list
        prompt_add_del_end
        system("clear")
      end
    end

    def prompt_add_del_end #Need to add a modify option
      loop do
        print "\nTask Options: (a)dd, (m)odify, (d)elete, (q)uit."
        response = gets.chomp
        case response
        when /(a|A|add|Add)/ then return add_task
        when /(d|D|del|Del|delete|Delete)/
          if @todo == [] #problem <---- If the todo list is empty, cannot choose delete.
            system("clear")
            welcome
            puts "\nYour list is empty! You have nothing here to delete."
          else
            return del_task
          end
        when /(m|M|modify|Modify)/
          if @todo == []
            system("clear")
            welcome
            puts "\nYour list is empty! You have nothing here to modify."
          else
            return mod_task
          end
        when /(q|Q|quit|Quit)/
          send_to_csv ####-----------------< This one. Trying to save list b/w sessions
          exit
        else
          puts "___________________________"
          puts "That is not a valid option."
        end
      end
    end

    def ask_task
      print "\nWhat task would you like to add to your list? > "
      gets.chomp
    end

    def ask_complete
      loop do
      print "\nIs this task (c)omplete or (i)ncomplete? > "
      response = gets.chomp
        case response
        when /(c|C|complete|Complete)/ then return "Complete"
        when /(i|I|incomplete|Incomplete)/ then return "Incomplete"
        else
          puts "Sorry, I didn't get that...\n\n"
        end
      end
    end

    def add_task
      @todo << { :task => "#{ask_task}", :complete => "#{ask_complete}" }
      send_to_csv
    end

    def send_to_csv
      CSV.open("todo.csv", "w") do |csv|
        csv << ["Task", "Complete"]
        @todo.each do |todo|
          csv << [todo[:task], todo[:complete]]
        end
      end
    end

    def mod_task
      loop do
        print "\nPlease select a task you would like to modify. > "
        response = gets.chomp
        if response == (@task_num + 1).to_s
          if todo_list[response.to_i - 1][:complete] == "Incomplete"
            return todo_list[response.to_i - 1].replace({:task => todo_list[response.to_i - 1].fetch(:task), :complete => "Complete"})
          else
            return todo_list[response.to_i - 1].replace({:task => todo_list[response.to_i - 1].fetch(:task), :complete => "Incomplete"})
          end
        else
          puts "______________________________"
          puts "Please make a valid selection."
        end
      end
      send_to_csv
    end

    def del_task #prompts users to delete a task; deletes that task
      loop do
      print "\nPlease select a task you would like to delete. > "
      response = gets.chomp
        if response == (@task_num + 1).to_s
          return todo_list.delete_at(response.to_i - 1)
        else
          puts "______________________________"
          puts "Please make a valid selection."
        end
      end


      send_to_csv
    end

    def read_todo_list
      puts
      CSV.foreach("todo.csv", headers: true, header_converters: :symbol) do |row|
        puts "Task #{@task_num}: #{row[:task]} [#{row[:complete]}]."
        @task_num += 1
      end
    end
  end

  Todo.new.run

  # require 'pry'; binding.pry
