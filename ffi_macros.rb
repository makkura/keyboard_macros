require_relative 'keys'

# Overloads for ease of use
class Object
  def is_number?
    true if Float(self) rescue false
  end
end

class Object
	def is_integer?
		true if Integer(self) rescue false
	end
end

# Testing
commands = Commands.new

getting_input = true
running = true
while(running)
	while(getting_input)
	
		system("clear") 
		system("cls")
		
		puts "Utils:"
		puts "(GC) Buy"
		puts "(Re)peat Craft"
		puts "E(x)it"
		print ">"

		input = gets.chomp
		puts ""

		case input.upcase
			when "X", "EXIT"
				puts "Closing Program ..."
				getting_input = false
				running = false
			when "GC", "GC BUY"
				quantity = 0
				while( !quantity.is_integer? or quantity.to_i < 1)
					system("clear")
					system("cls")
				
					print "Quantity: "
					quantity = gets.chomp
				end
				sleep(15)
				commands.GCBuy(quantity)
			when "RE", "REPEAT CRAFT"
				quantity = 0
				while( !quantity.is_integer? or quantity.to_i < 1)
					system("clear")
					system("cls")
				
					print "Quantity: "
					quantity = gets.chomp
				end
				sleep(15)
				commands.RepeatCraft(quantity)
			else
				puts "Invalid input. Please use a listed command."
				system("PAUSE")
		end
	end
end
