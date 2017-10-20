tests- basic reading
testMessageCacheHit
	| messages |
	messages := session readManyOf: GlorpMessage.
	messages do: [:each | | individualMessages individualMessage otherIndividualMessage|
		individualMessages := session readManyOf: GlorpMessage where: [:eachMessage | eachMessage = each].
		self assert: individualMessages size = 1.
		individualMessage := individualMessages first.
		session accessor denyReads.
		otherIndividualMessage := session readOneOf: GlorpMessage where: [:eachMessage | eachMessage = each].
		session accessor resetPermissions.
		self assert: individualMessage == each.
		self assert: otherIndividualMessage == individualMessage].