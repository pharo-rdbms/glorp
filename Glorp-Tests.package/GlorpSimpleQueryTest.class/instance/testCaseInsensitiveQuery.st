tests
testCaseInsensitiveQuery
	| result |
	session platform supportsCaseInsensitiveLike ifFalse: [^self].
	[session beginUnitOfWork.
	session beginTransaction.
	session register: GlorpAddress example1.
	session commitUnitOfWork.
	result := session
				readOneOf: GlorpAddress
				where: [:address | address street ilike: 'WeSt%'].
	self assert: result street = 'West 47th Ave'] 
			ensure: [session rollbackTransaction]