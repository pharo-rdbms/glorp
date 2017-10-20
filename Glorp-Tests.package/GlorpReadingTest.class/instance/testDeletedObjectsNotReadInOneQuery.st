tests
testDeletedObjectsNotReadInOneQuery
	| query anAccount someAccountId account |
	[session beginTransaction.
	someAccountId := self writeCustomer1Rows first.
	session beginUnitOfWork.
	query := Query readOneOf: GlorpBankAccount
				where: [:each | each id = someAccountId].
	anAccount := session execute: query.
	self assert: anAccount class == GlorpBankAccount.
	self assert: anAccount id = someAccountId.
	session delete: anAccount.
	account := session readOneOf: GlorpBankAccount where: [:each | each id = someAccountId].
	self assert: account isNil] 
			ensure: [session rollbackTransaction]