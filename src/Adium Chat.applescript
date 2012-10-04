#ver 2.0.1
on alfred_script(q)

	set input to "" & q
	set msg to ""

	#get the name portion of the string
	set AppleScript's text item delimiters to {":"}
	set chatParts to (every text item in input) as list
	set user to item 1 of chatParts

	#get the message portion of the string
	set AppleScript's text item delimiters to {""}
	if (length of input > (length of user) + 1) then
		set start to the (length of the (user & ":")) + 1
		set msg to text start thru end of input
	end if

	tell application "System Events"
		set theCount to count (every process whose name contains "Adium")
	end tell

	if theCount = 0 then
		tell application "Adium"
			activate
		end tell
		delay 5
	end if

	tell application "Adium"
		set user to first contact whose (display name contains user)

		if not (exists (chats whose contacts contains user)) then
			if not (exists (first chat window)) then
				if (length of msg is greater than 0) and (user is not equal to msg) then
					tell account of user to (make new chat with contacts {user} with new chat window)
					send (first chat whose contacts contains user) message msg
				else
					tell account of user to (make new chat with contacts {user} with new chat window)
				end if
			else
				set existing_window to first chat window
				if (length of msg is greater than 0 and user is not equal to msg) then
					tell account of user to (make new chat with contacts {user} in window existing_window)
					send (first chat whose contacts contains user) message msg
				else
					tell account of user to (make new chat with contacts {user} in window existing_window)
				end if
			end if
		else
			if (length of msg is greater than 0 and user is not equal to msg) then
				send (first chat whose contacts contains user) message msg
			end if
		end if
		tell (first chat whose contacts contains user) to become active
		tell (first chat whose contacts contains user) to activate
	end tell

end alfred_script