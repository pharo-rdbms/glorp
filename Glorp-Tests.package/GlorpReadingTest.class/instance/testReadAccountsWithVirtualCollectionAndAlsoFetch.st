tests
testReadAccountsWithVirtualCollectionAndAlsoFetch
	| query result |
	 
	[| block |
	((session system descriptorFor: GlorpBankAccount) mappingForAttributeNamed: #accountHolders) collectionType: GlorpVirtualCollection.
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:account | 
			(account accountHolders anySatisfyExists: [:each | each id = 24]) 
				| (account accountHolders anySatisfyJoin: [:each | each id = 27])].
	query := Query read: GlorpBankAccount where: block.
	query alsoFetch: #accountHolders.
	result := session execute: query.
	self assert: result size = 2.
	self assert: result first accountHolders class == OrderedCollection] 
			ensure: [
				((session system descriptorFor: GlorpBankAccount) mappingForAttributeNamed: #accountHolders) collectionType: OrderedCollection.
				session rollbackTransaction]