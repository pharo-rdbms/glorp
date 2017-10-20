tests
testReadPersonWithEmailAddresses
	| query result emailAddresses |
	query := Query
		readOneOf:GlorpPerson
		where: [:person | person id = 3].
	result := query executeIn: session.
	emailAddresses := result emailAddresses getValue.
	self assert: emailAddresses size = 2.
	self
		assert:
			(emailAddresses first id = id1 or: [emailAddresses last id = id1]).
	self
		assert:
			(emailAddresses first id = id2 or: [emailAddresses last id = id2]).
	self assert: emailAddresses first id ~= emailAddresses last id.