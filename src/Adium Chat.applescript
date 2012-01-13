on alfred_script(q)
	
	set theString to "" & q
	set theMessage to theString
	
	#get the name portion of the string
	set AppleScript's text item delimiters to {":"}
	set chatParts to (every text item in theString) as list
	set theName to item 1 of chatParts
	
	#get the message portion of the string
	-- 0 = beginning, 1 = end, 2 = both
	set AppleScript's text item delimiters to {""}
	set x to the length of the (theName & ":")
	-- TRIM BEGINNING
	repeat while theMessage begins with the (theName & ":")
		try
			set theMessage to characters (x + 1) thru -1 of theMessage as string
		on error
			-- the text contains nothing but the trim characters
			return ""
		end try
	end repeat
	#end of get the message portion of the string
	
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
		try
			set theContact to get name of first contact whose display name contains theName
			if length of theContact > 0 then
				tell application "Adium" to set theAccount to the account of the contact theContact
				tell theAccount to set newChat to make new chat with contacts {contact theContact} with new chat window
				if length of theMessage is greater than 0 and theName is not equal to theMessage then
					tell application "Adium" to send newChat message theMessage
				end if
			end if
		on error
			tell application "System Events"
				set isRunning to (count of (every process whose bundle identifier is "com.Growl.GrowlHelperApp")) > 0
			end tell
			
			if isRunning then
				tell application id "com.Growl.GrowlHelperApp"
					-- Make a list of all the notification types 
					-- that this script will ever send:
					set the allNotificationsList to ¬
						{"Notification"}
					
					-- Make a list of the notifications 
					-- that will be enabled by default.      
					-- Those not enabled by default can be enabled later 
					-- in the 'Applications' tab of the growl prefpane.
					set the enabledNotificationsList to ¬
						{"Notification"}
					
					-- Register our script with growl.
					-- You can optionally (as here) set a default icon 
					-- for this script's notifications.
					register as application ¬
						"Alfred Adium Chat Script" all notifications allNotificationsList ¬
						default notifications enabledNotificationsList ¬
						icon of application "Adium"
					
					--       Send a Notification...
					notify with name ¬
						"Notification" title ¬
						"" & theName & " not found" description ¬
						"Sorry. I was unable to find the Adium contact with '" & theName & "' in it's display name" application name "Alfred Adium Chat Script"
					
				end tell
			end if
			
		end try
	end tell
	
end alfred_script