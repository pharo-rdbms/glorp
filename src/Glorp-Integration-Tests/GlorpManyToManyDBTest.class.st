Class {
	#name : #GlorpManyToManyDBTest,
	#superclass : #GlorpMappingDBTest,
	#instVars : [
		'customer',
		'customerId',
		'accountId1',
		'accountId2',
		'accountId3',
		'treeNodeClass'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #support }
GlorpManyToManyDBTest >> checkAccounts [

	| sorted numberOfAccounts |
	numberOfAccounts := (accountId1 isNil ifTrue: [0] ifFalse: [1]) + (accountId2 isNil ifTrue: [0] ifFalse: [1]) + (accountId3 isNil ifTrue: [0] ifFalse: [1]).
	self assert: customer accounts size = numberOfAccounts.
	sorted := customer accounts asSortedCollection: [:a :b | a id <= b id].
	accountId1 isNil ifFalse: [self assert: sorted first id = accountId1].
	accountId2 isNil ifFalse: [self assert: (sorted at: 2) id = accountId2].
	accountId3 isNil ifFalse: [self assert: sorted last id = accountId3].
	self assert: (customer accounts collect: [:each | each id]) asSet size = customer accounts size.
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> checkNumberOfAccounts: anInteger [
	| accountRows |
	accountRows := session accessor
		executeSQLString: 'SELECT * FROM BANK_ACCT'.
	self assert: accountRows size = anInteger.
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> checkNumberOfLinkRows: anInteger [
	| linkRows |
	linkRows := session accessor
		executeSQLString: 'SELECT * FROM CUSTOMER_ACCT_LINK'.
	self assert: linkRows size = anInteger.
]

{ #category : #support }
GlorpManyToManyDBTest >> inUnitOfWorkDo: aBlock initializeWith: initBlock [
	"Set up a bunch of the normal data, read the objects, then run the block in a unit of work"
	initBlock value.
	session beginUnitOfWork.
	self readCustomer.
	aBlock value.
	session commitUnitOfWork.
	session reset.
]

{ #category : #support }
GlorpManyToManyDBTest >> readCustomer [
	| results query |
	query := Query
		read: GlorpCustomer
		where: [:cust | cust id = customerId].
	results := query executeIn: session.
	self assert: results size = 1.
	customer := results first.
]

{ #category : #support }
GlorpManyToManyDBTest >> readCustomer: aCustomerId [
	| results query |
	query := Query
		read: GlorpCustomer
		where: [:cust | cust id = aCustomerId].
	results := query executeIn: session.
	self assert: results size = 1.
	^results first.
]

{ #category : #'As yet unclassified' }
GlorpManyToManyDBTest >> session: aDatabaseSession [
	session := aDatabaseSession.
]

{ #category : #'tests-nodes' }
GlorpManyToManyDBTest >> testReadAndDeleteNodes [
	"Make sure we don't delete out of order and that links disappear."
	| nodes links |
	self inTransactionDo: [
		self writeNodeWithChildren.
		session reset.
		session transact: [
			nodes := session read: GlorpTreeNode.
			nodes do: [:each | session delete: each]].
		links := session accessor executeSQLString: 'SELECT * FROM TREE_NODE_LINK'.
		self assert: links size = 0].
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> testReadCustomerAndAddAccount [
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [customer addAccount: (GlorpBankAccount new id: 77473)]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId3 := 77473.
			self checkAccounts.
			self checkNumberOfLinkRows: 4].
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> testReadCustomerAndDeleteAccount [
	self
		inTransactionDo:[
			[self 
				inUnitOfWorkDo: [ | account| 
					account := customer accounts detect: [:each | each id = 9874].
					session delete: account]
				initializeWith: [self writeCustomerWithAccounts]]
				on: Dialect error
				do: [:ex | Transcript show: 'integrity violation'; cr.^self].
			self readCustomer.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2.
			self checkNumberOfAccounts: 2].
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> testReadCustomerAndDeleteAccountProperly [
	"Do both the delete and the patching up of relationships"
	self
		inTransactionDo:
			[
			self 
				inUnitOfWorkDo: [ | account| 
					account := customer accounts detect: [:each | each id = 9874].
					session delete: account.
					customer removeAccount: account]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2.
			self checkNumberOfAccounts: 2].
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> testReadCustomerAndRemoveAccount [
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[| account |
					account := customer accounts detect: [:each | each id = 9874].
					customer accounts remove: account]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2].
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> testReadCustomerAndReplaceAccounts [
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[| account |
					account := GlorpBankAccount new id: 99999.
					customer accounts do: [:each | each accountHolders remove: customer].
					customer accounts: (Array with: account)]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId1 := 99999.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2.
			self checkNumberOfAccounts: 4].
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> testReadCustomerAndReplaceAccountsWithRemoval [
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[| account |
					account := customer accounts detect: [:each | each id = 6].
					customer accounts: (Array with: account)]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2].
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> testReadCustomerAndReplaceAccountsWithoutInstantiatingHolders [
	"This works, but only fortuitously. If the accounts haven't been read into memory, we don't have to remove their object-level references to the account holder, because changing one side of the relationship in memory is enough to cause the link rows to be deleted"
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[| account |
					account := GlorpBankAccount new id: 99999.
					customer accounts: (Array with: account)]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId1 := 99999.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 2.
			self checkNumberOfAccounts: 4].
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> testReadCustomerAndReplaceInstantiatedAccountsWithEmpty [
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[customer accounts yourSelf. 
					customer accounts: #()]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId1 := nil.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 1.
			self checkNumberOfAccounts: 3].
]

{ #category : #'tests-read' }
GlorpManyToManyDBTest >> testReadCustomerAndReplaceUninstantiatedAccountsWithEmpty [
	self
		inTransactionDo:
			[self
				inUnitOfWorkDo:
					[customer accounts: #()]
				initializeWith: [self writeCustomerWithAccounts].
			self readCustomer.
			accountId1 := nil.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfLinkRows: 1.
			self checkNumberOfAccounts: 3].
]

{ #category : #'tests-join' }
GlorpManyToManyDBTest >> testReadCustomerOrderByLinkTableField [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session read: GlorpCustomer.
			customers do: [:each | | sortedAccounts |
				sortedAccounts := each accounts asSortedCollection: [:a :b | a id <= b id].
				self assert: each accountsSortedById asArray = sortedAccounts asArray]].
]

{ #category : #'tests-join' }
GlorpManyToManyDBTest >> testReadCustomerOrderByLinkTableFieldDescending [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session read: GlorpCustomer.
			customers do: [:each | | sortedAccounts |
				sortedAccounts := each accounts asSortedCollection: [:a :b | a id <= b id].
				self assert: each accountsSortedByIdDescending asArray = sortedAccounts asArray reverse]].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerOrderingByCountSubselect [
	"DB2 (as of 9.8) does not support an ORDER BY clause with correlated column references.	The ORDER BY sub-select here refers back to the selected column, so we skip this for DB2. Access doesn't appear to allow anything in the ORDER BY clause except column names."

	| customers |
	(session platform supportsCorrelatedSubqueriesInOrderBy) ifFalse: [^self].
	self
		inTransactionDo:
			[| sorted |
			self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				orderBy: [:each | each accounts sqlCount].
			sorted := (customers asSortedCollection: [:a :b | a accounts size <= b accounts size]) asArray.
			self assert: customers = sorted.
			customers := session
				read: GlorpCustomer
				orderBy: [:each | each accounts sqlCount descending].
			self assert: customers reverse = sorted].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithAverageSubselect [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each average: [:eachCust | eachCust accounts id]) = ((9874 + 6) / 2)].
		self assert: customers size = 1.
		self assert: customers first id = 27.
		customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each accounts id sqlAverage) = 22].
		self assert: customers size = 1.
		self assert: customers first id = 28.].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithCountSubselect [

	| customersWithOneAccount customersWithTwoAccounts customersWithLessThanFiveAccounts |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customersWithOneAccount := session
				read: GlorpCustomer
				where:
					[:each | 
					(each getConstant: 1) = (each count: [:eachCust | eachCust accounts])].
			customersWithTwoAccounts := session
				read: GlorpCustomer
				where:
					[:each | 
					(each count: [:eachCust | eachCust accounts]) = 2].
			"fully general syntax. doesn't require any helper methods, just the existence of the function"
			customersWithLessThanFiveAccounts := session
				read: GlorpCustomer
				where: [:each | (each aggregate: each accounts as: #countStar) < 5].
		self assert: customersWithOneAccount size = 1.
		self assert: customersWithOneAccount first id = 28.
		self assert: customersWithTwoAccounts size = 1.
		self assert: customersWithTwoAccounts first id = 27.
		self assert: customersWithLessThanFiveAccounts size = 2].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithCountSubselectAlternateSyntax [

	| customersWithOneAccount customersWithTwoAccounts |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customersWithOneAccount := session
				read: GlorpCustomer
				where:
					[:each | 
					(each getConstant: 1) = (each accounts sqlCount)].
			customersWithTwoAccounts := session
				read: GlorpCustomer
				where:
					[:each | 
					each accounts sqlCount = 2].
		self assert: customersWithOneAccount size = 1.
		self assert: customersWithOneAccount first id = 28.
		self assert: customersWithTwoAccounts size = 1.
		self assert: customersWithTwoAccounts first id = 27].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithEqualityComparisonToAccountsUsingInClause [
	"Test doing a primary key rewrite of the where clause in a subselect, to the result of another subselect"

	| customers accounts |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			accounts := session read: GlorpBankAccount where: [:each | each id = 22].
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | eachAccount in: accounts]].
			self assert: customers size = 1.
			customers do: [:each | each accounts do: [:eachAcct | self assert: eachAcct id = 22]]].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithEqualitySubSelectToAccountsUsingInClause [
	"Test doing a primary key rewrite of the where clause in a subselect, to the result of another subselect"

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | eachAccount in: (Query read: GlorpBankAccount where: [:accts2 | accts2 id <> 12])]].
			self assert: customers size = 2.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | 
							eachAccount in: (Query read: GlorpBankAccount where: [:accts2 | accts2 id = 22])]].
			self assert: customers size = 1.
			customers do: [:each | each accounts do: [:eachAcct | self assert: eachAcct id = 22]]].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithFilteredSubSelectToAccounts1 [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					(eachCustomer accounts select: [:eachAccount | eachAccount accountNumber bankCode = '2']) sqlCount > 0].
			self assert: customers size = 2].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithFilteredSubSelectToAccounts2 [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					(eachCustomer accounts select: [:eachAccount | eachAccount accountNumber bankCode = '2']) sqlCount > 1].
			self assert: customers size = 0].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithFilteredSubSelectToAccounts3 [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					(eachCustomer accounts select: [:eachAccount | eachAccount id > 5 ]) sqlCount <= 1].
			self assert: customers size = 1].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithFilteredSubSelectToAccountsAndAggregate [
	"Test with a filtered read to accounts, where we've used an aggregate function to find the customer with the maximum primary key for the given id"

	| query |
	((session system descriptorFor: GlorpCustomer) mappingForAttributeNamed: #accounts) useFilteredRead.
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			query := Query readOneOf: GlorpCustomer where: [:each |
				| q |
				q := Query read: GlorpCustomer where: [:eachPundle |
					eachPundle name = 'aCustomer'].
				q retrieve: [:x | x id max].
				each id = q].
			customer := session execute: query.
			self assert: customer name = 'aCustomer'.
			self assert: (customer accounts collect: [:each | each id]) asSortedCollection asArray = #(6 9874)].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithIsEmptyAndFilteredSubselectsToAccounts [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | (eachCustomer accounts select: [:each | each id > 30]) isEmpty].
			self assert: customers size = 1.
			self assert: customers first id = 28].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithIsEmptySubselectToAccounts1 [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | eachCustomer accounts isEmpty].
			self assert: customers size = 0].
]

{ #category : #'tests-join' }
GlorpManyToManyDBTest >> testReadCustomerWithJoinToAccounts [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyJoin: [:eachAccount | eachAccount accountNumber bankCode = '2']].
			self assert: customers size = 2].
]

{ #category : #'tests-join' }
GlorpManyToManyDBTest >> testReadCustomerWithJoinToAccounts2 [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyJoin: [:eachAccount | eachAccount accountNumber branchNumber = 3]].
			self assert: customers size = 1].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithMaxSubselect [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each max: [:eachCust | eachCust accounts id]) = 9874].
		self assert: customers size = 1.
		self assert: customers first id = 27.
		customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each accounts id sqlMax) = 22].
		self assert: customers size = 1.
		self assert: customers first id = 28.].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithMinSubselect [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each min: [:eachCust | eachCust accounts id]) = 6].
		self assert: customers size = 1.
		self assert: customers first id = 27.
		customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each accounts id sqlMin) = 22].
		self assert: customers size = 1.
		self assert: customers first id = 28.].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithNotEmptyAndFilteredSubselectsToAccounts [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | (eachCustomer accounts select: [:each | each id > 30]) notEmpty].
			self assert: customers size = 1.
			self assert: customers first id = 27].
]

{ #category : #'tests-join' }
GlorpManyToManyDBTest >> testReadCustomerWithSimpleJoinToAccounts [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyJoin: [:eachAccount | eachAccount id <> 12]].
			self assert: customers size = 2].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithSimpleSubSelectToAccounts [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | eachAccount id <> 12]].
			self assert: customers size = 2].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithSubSelectToAccounts [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | eachAccount accountNumber bankCode = '2']].
			self assert: customers size = 2].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithSubSelectToAccounts2 [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | eachAccount accountNumber branchNumber = 3]].
			self assert: customers size = 1].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithSubSelectToAccountsUsingInClause [
	"Test doing an IN clause with the result of another subselect"

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | 
							| q |
							q := Query read: GlorpBankAccount where: [:accts2 | accts2 id <> 12].
							q retrieve: #id.
							eachAccount id in: q]].
			self assert: customers size = 2.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | 
							| q |
							q := Query read: GlorpBankAccount where: [:accts2 | accts2 id = 22].
							q retrieve: #id.
							eachAccount id in: q]].
			self assert: customers size = 1.
			customers do: [:each | each accounts do: [:eachAcct | self assert: eachAcct id = 22]].
].
]

{ #category : #'tests-subselect' }
GlorpManyToManyDBTest >> testReadCustomerWithSumSubselect [

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each sum: [:eachCust | eachCust accounts accountNumber branchNumber]) < 6].
		self assert: customers size = 1.
		self assert: customers first id = 27.
		customers := session
				read: GlorpCustomer
				where:
					[:each | 
					(each accounts accountNumber branchNumber sqlSum) > 6].
		self assert: customers size = 1.
		self assert: customers first id = 28.].
]

{ #category : #'tests-nodes' }
GlorpManyToManyDBTest >> testReadNode [
	| allNodes |
	self inTransactionDo: [
		self writeNodeWithChildren.
		session reset.
		allNodes := session read: GlorpTreeNode orderBy: #id.
		self assert: (allNodes collect: [:each | each id]) asArray = #( 1 2 3).
		self assert: allNodes first children size = 2.
		self assert: (allNodes first children collect: [:each | each id]) asSortedCollection asArray = #( 2 3)].
]

{ #category : #'tests-nodes' }
GlorpManyToManyDBTest >> testReadNodeAndDeleteChild [
	| node1 node3 links nodes |
	self inTransactionDo: [
		self writeNodeWithChildren.
		session reset.
		node1 := session readOneOf: GlorpTreeNode where: [:each | each id = 1].
		node3 := (node1 children asSortedCollection: [:a :b | a id <= b id]) last.
		session transact: [
			session register: node1.
			session delete: node3.
			node1 children remove: node3].
		links := session accessor executeSQLString: 'SELECT * FROM TREE_NODE_LINK'.
		self assert: links size = 1.
		self assert: links first first = 1. 
		self assert: links first last = 2.
		nodes := session accessor executeSQLString: 'SELECT * FROM TREE_NODE'.
		self deny: (nodes anySatisfy: [:each | each first = node3 id]).
		self assert: nodes size = 2
		].
]

{ #category : #'tests-nodes' }
GlorpManyToManyDBTest >> testReadNodeAndDeleteChildWithSaveAndContinue [
	"This exercises two things. First, there's a bug in save and continue with deleted objects resurrecting. Second, make sure that if we delete both parent and child, the link goes away"
	| node1 node3 links nodes node2 |
	self inTransactionDo: [
		self writeNodeWithChildren.
		session reset.
		node1 := session readOneOf: GlorpTreeNode where: [:each | each id = 1].
		node2 := (node1 children asSortedCollection: [:a :b | a id <= b id]) first.
		node3 := (node1 children asSortedCollection: [:a :b | a id <= b id]) last.
		session beginUnitOfWork.
			[session register: node1.
			session delete: node3.
			node1 children remove: node3] ensure: [session saveAndContinue].
		links := session accessor executeSQLString: 'SELECT * FROM TREE_NODE_LINK'.
		self assert: links size = 1.
		self assert: links first first = 1. 
		self assert: links first last = 2.
		nodes := session accessor executeSQLString: 'SELECT * FROM TREE_NODE'.
		self deny: (nodes anySatisfy: [:each | each first = node3 id]).
		self assert: nodes size = 2.

			[session register: node1.
			session delete: node2.
			session delete: node1] ensure: [session saveAndContinue].
		nodes := session accessor executeSQLString: 'SELECT * FROM TREE_NODE'.
		self assert: nodes isEmpty.
		links := session accessor executeSQLString: 'SELECT * FROM TREE_NODE_LINK'.
		self assert: links isEmpty.
		].
]

{ #category : #'tests-nodes' }
GlorpManyToManyDBTest >> testReadNodeAndDeleteParent [
	| node1 links |
	self inTransactionDo: [
		self writeNodeWithChildren.
		session reset.
		session transact: [
		node1 := session readOneOf: GlorpTreeNode where: [:each | each id = 1].
		session delete: node1.
		node1 children: #()].
		links := session accessor executeSQLString: 'SELECT * FROM TREE_NODE_LINK'.
		self assert: links size = 0].
]

{ #category : #'tests-write' }
GlorpManyToManyDBTest >> testWriteCustomerWithAccounts [
	| newCustomer |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			session beginUnitOfWork.
			newCustomer := GlorpCustomer example1.
			newCustomer id: 12.
			customerId := 12.
			newCustomer accounts: (OrderedCollection with: (GlorpBankAccount new id: 223)).
			session register: newCustomer.
			session commitUnitOfWork.
			session reset.
			self readCustomer.
			accountId1 := 223.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfAccounts: 4.
			self checkNumberOfLinkRows: 4].
]

{ #category : #'tests-write' }
GlorpManyToManyDBTest >> testWriteCustomerWithNoAccounts [
	| newCustomer |
	self
		inTransactionDo:
			[session beginUnitOfWork.
			newCustomer := GlorpCustomer example1.
			newCustomer id: 12.
			customerId := 12.
			session register: newCustomer.
			session commitUnitOfWork.
			session reset.
			self readCustomer.
			accountId1 := nil.
			accountId2 := nil.
			self checkAccounts.
			self checkNumberOfAccounts: 0.
			self checkNumberOfLinkRows: 0].
]

{ #category : #'tests-write' }
GlorpManyToManyDBTest >> testWriteCustomerWithTwoAccounts [
	| newCustomer |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			session beginUnitOfWork.
			newCustomer := GlorpCustomer example1.
			newCustomer id: 12.
			customerId := 12.
			newCustomer accounts: (OrderedCollection with: (GlorpBankAccount new id: 223)).
			newCustomer accounts add: (GlorpBankAccount new id: 224).
			session register: newCustomer.
			session commitUnitOfWork.
			session reset.
			self readCustomer.
			accountId1 := 223.
			accountId2 := 224.
			self checkAccounts.
			self checkNumberOfAccounts: 5.
			self checkNumberOfLinkRows: 5].
]

{ #category : #'tests-write' }
GlorpManyToManyDBTest >> testWriteCustomersAndAccounts [
	| newCustomer1 newCustomer2 newCustomer3 joint withBaby1 withBaby2 hisChecking herChecking |
	self
		inTransactionDo:
			[
			session beginUnitOfWork.
			newCustomer1 := GlorpCustomer exampleD1.
			newCustomer2 := GlorpCustomer exampleD2.
			newCustomer3 := GlorpCustomer exampleD3.
			hisChecking := GlorpBankAccount new id: 301.
			herChecking := GlorpBankAccount new id: 302.
			joint := GlorpBankAccount new id: 303.
			withBaby1 := GlorpBankAccount new id: 304.
			withBaby2 := GlorpBankAccount new id: 305.
			newCustomer1 id: 201; accounts: (OrderedCollection with: hisChecking with: joint with: withBaby1).
			newCustomer2 id: 202; accounts: (OrderedCollection with: herChecking with: joint with: withBaby2).
			newCustomer3 id: 203; accounts: (OrderedCollection with: withBaby1 with: withBaby2).
			session register: newCustomer1;
				register: newCustomer2;
				register: newCustomer3.
			session commitUnitOfWork.
			session reset.
			newCustomer1 := self readCustomer: 201.
			self assert: newCustomer1 accounts size = 3.
			newCustomer2 := self readCustomer: 202.
			self assert: newCustomer2 accounts size = 3.
			newCustomer3 := self readCustomer: 203.
			self assert: newCustomer3 accounts size = 2.
			self checkNumberOfAccounts: 5.
			self checkNumberOfLinkRows: 8].
]

{ #category : #'tests-write' }
GlorpManyToManyDBTest >> testWriteCustomersAndAccountsAndDelete [
	| newCustomer1 newCustomer2 newCustomer3 joint withBaby1 withBaby2 hisChecking herChecking |
	self
		inTransactionDo:
			[
			session beginUnitOfWork.
			newCustomer1 := GlorpCustomer exampleD1.
			newCustomer2 := GlorpCustomer exampleD2.
			newCustomer3 := GlorpCustomer exampleD3.
			hisChecking := GlorpBankAccount new id: 301.
			herChecking := GlorpBankAccount new id: 302.
			joint := GlorpBankAccount new id: 303.
			withBaby1 := GlorpBankAccount new id: 304.
			withBaby2 := GlorpBankAccount new id: 305.
			newCustomer1 id: 201; accounts: (OrderedCollection with: hisChecking with: joint with: withBaby1).
			newCustomer2 id: 202; accounts: (OrderedCollection with: herChecking with: joint with: withBaby2).
			newCustomer3 id: 203; accounts: (OrderedCollection with: withBaby1 with: withBaby2).
			session register: newCustomer1;
				register: newCustomer2;
				register: newCustomer3.
			session commitUnitOfWork.
			session reset.
			newCustomer1 := self readCustomer: 201.
			self assert: newCustomer1 accounts size = 3.
			newCustomer2 := self readCustomer: 202.
			self assert: newCustomer2 accounts size = 3.
			newCustomer3 := self readCustomer: 203.
			self assert: newCustomer3 accounts size = 2.
			self checkNumberOfAccounts: 5.
			self checkNumberOfLinkRows: 8.
			session reset.	
			session transact: [ | cust acct |		
				cust := self readCustomer: 201.
				acct := cust accounts detect: [:ea| ea id = 301] ifNone: [nil].
				acct notNil ifTrue: [session delete: acct].
				session delete: cust].
			self checkNumberOfAccounts: 4.
			self checkNumberOfLinkRows: 5].
]

{ #category : #'tests-nodes' }
GlorpManyToManyDBTest >> treeNodeClass [
	treeNodeClass isNil ifTrue: [treeNodeClass := GlorpTreeNode].
	^treeNodeClass.
]

{ #category : #'tests-nodes' }
GlorpManyToManyDBTest >> treeNodeClass: aClass [
	treeNodeClass := aClass.
]

{ #category : #support }
GlorpManyToManyDBTest >> writeCustomerWithAccounts [
	| customerRow accountRow1 accountRow2 linkRow1 linkRow2 customerRow2 accountRow3 linkRow3 |

	customerRow := session system exampleCustomerRow1.
	customerId := customerRow atFieldNamed: 'ID'.
	customerRow2 := session system exampleCustomerRow2.
	accountRow1 := session system exampleAccountRow1. 
	accountId2 := accountRow1 atFieldNamed: 'ID'.
	accountRow2 := session system exampleAccountRow2.
	accountId1 := accountRow2 atFieldNamed: 'ID'.
	accountRow3 := session system exampleAccountRow3.
	linkRow1 := session system exampleCALinkRow1.
	linkRow2 := session system exampleCALinkRow2.
	linkRow3 := session system exampleCALinkRow3.
	session writeRow: customerRow.
	session writeRow: customerRow2.
	session writeRow: accountRow1.
	session writeRow: accountRow2.
	session writeRow: accountRow3.
	session writeRow: linkRow1.
	session writeRow: linkRow2.
	session writeRow: linkRow3.
]

{ #category : #'tests-nodes' }
GlorpManyToManyDBTest >> writeNodeWithChildren [
	| node1 node2 node2a |
	node1 := self treeNodeClass new id: 1.
	node2 := self treeNodeClass new id: 2.
	node2a := self treeNodeClass new id: 3.
	node1 children add: node2.
	node1 children add: node2a.
	session inUnitOfWorkDo: [session register: node1].
]
