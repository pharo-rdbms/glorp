tests
testReadQueryingAttributes
	| branches |
	branches := session read: GlorpBankBranch where: [:each |
		each accounts anySatisfy: [:eachAccount |
			eachAccount accountNumber accountNumber in: #( '3' '4')]].
	self assert: branches size = 2.
	self assert: branches asSet size = 2.