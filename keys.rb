require 'ffi'

# Win module passes keystrokes to the active program
module Win
	# virtual keyboard values
	Keys = {
		'VK_NUMPAD0' => 0x60, 
		'VK_NUMPAD1' => 0x61,
		'VK_NUMPAD2' => 0x62,
		'VK_NUMPAD3' => 0x63,
		'VK_NUMPAD4' => 0x64,
		'VK_NUMPAD5' => 0x65,
		'VK_NUMPAD6' => 0x66,
		'VK_NUMPAD7' => 0x67,
		'VK_NUMPAD8' => 0x68,
		'VK_NUMPAD9' => 0x69,
		'VK_LSHIFT' => 0xA0,
		'VK_OEM_MINUS' => 0xBD,
		'VK_OEM_PLUS' => 0xBB,
		'KEYEVENTF_KEYDOWN' => 0, # Key up and down events
		'KEYEVENTF_KEYUP' => 2,
		# Friendly key names
		'Accept' => 0x60, # FFXIV: Numpad 0 acts as accept
		'Up' => 0x68,
		'Down' => 0x62,
		'Left' => 0x64,
		'Right' => 0x66,
		'Shift' => 0xA0,
		'0' => 0x30,
		'1' => 0x31,
		'2' => 0x32,
		'3' => 0x33,
		'4' => 0x34,
		'5' => 0x35,
		'6' => 0x36,
		'7' => 0x37,
		'8' => 0x38,
		'9' => 0x39,
		'-' => 0xBD,
		'=' => 0xBB
	}

	extend FFI::Library
	ffi_lib 'user32'
	ffi_convention :stdcall

	attach_function :keybd_event, [ :uchar, :uchar, :int, :pointer ], :void

	# Simulate single key press with 1 second sleep afterwards
	def Win.Action(action)
		return unless Keys.has_key? action

		keybd_event(Keys[action], 0, Keys['KEYEVENTF_KEYDOWN'], nil);
  		keybd_event(Keys[action], 0, Keys['KEYEVENTF_KEYUP'], nil);
  		sleep(1)
	end

	# Simluate a keypress with second key or modifier such as control, alt, etc
	def Win.TwoKeyAction(action, modifier)
		return unless Keys.has_key? action

		keybd_event(Keys[modifier], 0, Keys['KEYEVENTF_KEYDOWN'], nil);
		sleep(0.5)
		keybd_event(Keys[action], 0, Keys['KEYEVENTF_KEYDOWN'], nil);
  		keybd_event(Keys[action], 0, Keys['KEYEVENTF_KEYUP'], nil);
  		sleep(0.5)
  		keybd_event(Keys[modifier], 0, Keys['KEYEVENTF_KEYUP'], nil);
  		sleep(1)
	end

	# Send a straight pass through of the key for unmapped keys
	def Win.KeyPassthrough(key)
		keybd_event(key, 0, Keys['KEYEVENTF_KEYDOWN'], nil);
  		keybd_event(key, 0, Keys['KEYEVENTF_KEYUP'], nil);
  		sleep(1)	
	end

end

# Commands handles friendly named keypresses using the Win module
class Commands
	include Win

	# 1 step commands
	def Accept
		Win.Action('Accept')
	end
	def Up
		Win.Action('Up')
	end
	def Down
		Win.Action('Down')
	end
	def Left
		Win.Action('Left')
	end
	def Right
		Win.Action('Right')
	end

	# Multistep Commands

	# FullAccept
	# Presses the Accept button three times
	# Used for repeat crafting of the same item to restart the craft process
	def FullAccept
		3.times do 
			self.Accept
		end
	end

	# GCBuy
	# Accept to select item, Left to move to Ok to acknowledge purchase, Accept to actually purchase
	def GCBuy(quantity)
		quantity.to_i.times do
			Win.Action("Accept")
			Win.Action("Left")
			Win.Action("Accept")
		end
	end

	# RepeatCraft
	# Essentially a macro simulating reselecting the last crafted item 
	# and pressing =, waiting 50s, pressing -, and waiting 20s
	def RepeatCraft(quantity)
		quantity.to_i.times do 
			self.FullAccept
			Win.Action("=")
			sleep(50)
			Win.Action("-")
			sleep(20)
		end
	end
end
