tests- basic reading
testUserIdentityViaMessage
	| users |
	users := session read: GlorpUser.
	users
		do:
			[:each | 
			each folders
				do:
					[:eachFolder | 
					eachFolder messages
						do: [:eachMessage | 
							self assert: eachMessage folder yourSelf == eachFolder.
							self assert: eachMessage user yourSelf == each]]].