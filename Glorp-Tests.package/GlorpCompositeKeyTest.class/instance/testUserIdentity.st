tests- basic reading
testUserIdentity
	| users |
	users := session read: GlorpUser.
	users
		do:
			[:each | 
			| individualUser otherIndividualUser individualUsers |
			individualUsers := session
				read: GlorpUser
				where: [:eachIndividual | eachIndividual id = each id].
			self assert: individualUsers size = 1.
			individualUser := individualUsers first.
			otherIndividualUser := session
				readOneOf: GlorpUser
				where: [:eachIndividual | eachIndividual id = each id].
			self assert: individualUser == each.
			self assert: otherIndividualUser == individualUser].