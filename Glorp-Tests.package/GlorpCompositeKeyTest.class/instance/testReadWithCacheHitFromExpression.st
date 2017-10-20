tests- basic reading
testReadWithCacheHitFromExpression
	| message |
	session reset.
	message := session readOneOf: GlorpMessage where: [:each | each subject = 'goes in folder 1'].
	self assert: message folder name = 'One'.
	session accessor permitNothing.
	session readOneOf: GlorpFolder where: [:each | each user id = 1 & (each name = 'One')].