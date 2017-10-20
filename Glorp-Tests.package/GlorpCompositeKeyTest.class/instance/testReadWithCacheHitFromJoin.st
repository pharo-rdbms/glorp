tests- basic reading
testReadWithCacheHitFromJoin
	| message |
	session reset.
	message := session readOneOf: GlorpMessage where: [:each | each subject = 'goes in folder 1'].
	session readOneOf: GlorpFolder where: [:each | each user id = 1 & (each name = 'One')].
	session accessor permitNothing.
	self assert: message folder name = 'One'.