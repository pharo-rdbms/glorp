tests
testDeletedObjectsNotReadInManyQuery
	| query anAccount accounts someAccountId |
	[session beginTransaction.
	someAccountId := self writeCustomer1Rows first.
	session beginUnitOfWork.
	query := Query readOneOf: GlorpBankAccount
				where: [:each | each id = someAccountId].
	anAccount := session execute: query.
	self assert: anAccount class == GlorpBankAccount.
	self assert: anAccount id = someAccountId.
	session delete: anAccount.
	accounts := session read: GlorpBankAccount.
	self assert: accounts size = 1.
	self deny: (accounts includes: anAccount).
	self deny: (accounts anySatisfy: [:each | each id = someAccountId]).
] 
			ensure: [session rollbackTransaction]