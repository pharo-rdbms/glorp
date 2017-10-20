tests- basic reading
testMessageIdentity
	| messages |
	messages := session read: GlorpMessage.
	messages do: [:each | | individualMessages individualMessage otherIndividualMessage|
		individualMessages := session read: GlorpMessage where: [:eachMessage | eachMessage = each].
		self assert: individualMessages size = 1.
		individualMessage := individualMessages first.
		otherIndividualMessage := session readOneOf: GlorpMessage where: [:eachMessage | eachMessage = each].
		self assert: individualMessage == each.
		self assert: otherIndividualMessage == individualMessage].