tests- basic reading
testReadWithCacheHitFromParameterizedExpression
	| message query |
	session reset.
	message := session readOneOf: GlorpMessage where: [:each | each subject = 'goes in folder 1'].
	self assert: message folder name = 'One'.
	session accessor permitNothing.
	query := Query readOneOf: GlorpFolder where: [:each | each user id = (each parameter: 1)  & (each name = (each parameter: 2))].
	query executeWithParameters: #(1 'One') in: session.