tests-registration
testRegisterEmbeddedInTargetDontRefetch
	" This tests for a problem with embedded objects suddenly becoming nil. This can happen when an object is part of a to-many relation. If the relation is followed during the registering phase the query will wrongly replace the embedded object even though requiresPopulating is false. When the object itself is already registered the replaced embedded object won't be registered."

	| transactionId customer |
	
	[session beginTransaction.
	session inUnitOfWorkDo: 
			[customer := GlorpCustomer example1.
			customer id: 42.
			session register: customer].
	transactionId := customer transactions first id.
	customer := nil.
	session initializeCache.
	session inUnitOfWorkDo: 
			[| transaction amount |
			transaction := session readOneOf: GlorpBankTransaction
						where: [:each | each id = transactionId].
			amount := transaction amount.
			transaction owner transactions getValue.
			self assert: amount == transaction amount]] 
			ensure: [session rollbackTransaction]