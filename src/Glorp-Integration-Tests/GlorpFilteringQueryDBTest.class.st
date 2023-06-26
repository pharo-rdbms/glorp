Class {
	#name : #GlorpFilteringQueryDBTest,
	#superclass : #GlorpSessionBasedTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #running }
GlorpFilteringQueryDBTest >> setUp [

	super setUp.
	session beginTransaction
]

{ #category : #running }
GlorpFilteringQueryDBTest >> tearDown [

	session rollbackTransaction.
	session resetPermissions.
	super tearDown
]

{ #category : #tests }
GlorpFilteringQueryDBTest >> testReadDictionary [
	| entryMapping encyclopedias query readBackEncyclopedias canadian plagiarists |
	session system: (GlorpEncyclopediaDescriptorSystem forPlatform: session platform).
	system := session system.
	encyclopedias := system exampleEncyclopedias.
	entryMapping := (system descriptorFor: GlorpEncyclopedia) mappingForAttributeNamed: #entries.
	entryMapping useFilteredRead.
	session transact: [session register: encyclopedias].
	session reset.
	query := Query read: GlorpEncyclopedia.
	query orderBy: [:each | each name].
	readBackEncyclopedias := session execute: query.
	canadian := readBackEncyclopedias first.
	self assert: canadian entries size = 3.
	session accessor permitNothing.

	self assert: (canadian entries at: 'abcde') id = 'two'.
	self assert: (canadian entries at: '12345') id = 'one'.
	self assert: (canadian entries at: 'unique') id = 'three'.
	plagiarists := readBackEncyclopedias at: 2.
	self assert: plagiarists entries size = 2.
	self assert: (plagiarists entries at: '54321') = (canadian entries at: '12345').
	self assert: (plagiarists entries at: 'edcba') = (canadian entries at: 'abcde').
	self assert: readBackEncyclopedias last entries isEmpty.
]

{ #category : #tests }
GlorpFilteringQueryDBTest >> testReadOneToMany [
	"This doesn't actually short-circuit interestingly, because of the shared holder"
	| accounts txMapping tx1 tx2 otherHolder |
	(GlorpReadingTest new session: session) write2CustomerRowsWith3Transactions.
	txMapping := (system descriptorFor: GlorpCustomer) mappingForAttributeNamed: #transactions.
	txMapping useFilteredRead.
	accounts := session execute: ((Query read: GlorpBankAccount where: [:each | each id ~= 2]) orderBy: [:each | each id]).
	"Account 9874, 1 holder, 2 transactions"
	tx1 := accounts last accountHolders first transactions.
	"Account 6, 2 holders, 1 with 1 transaction, 1 shared with 9874" 
	otherHolder := accounts first accountHolders detect: [:each | each id = 28].
	tx2 := otherHolder transactions.
	self assert: (tx1 collect: [:each | each amount currency]) asSortedCollection asArray = #(#CDN #USD).
	self assert: (tx2 collect: [:each | each amount currency]) asSortedCollection asArray = #(EUR).
]

{ #category : #tests }
GlorpFilteringQueryDBTest >> testReadOneToMany2 [
	| accounts txMapping otherHolder holder |
	(GlorpReadingTest new session: session) write2CustomerRowsWith3Transactions.
	txMapping := (system descriptorFor: GlorpCustomer) mappingForAttributeNamed: #transactions.
	txMapping useFilteredRead.
	accounts := session execute: ((Query read: GlorpBankAccount where: [:each | each id ~= 2]) orderBy: [:each | each id]).
	"Account 6, 2 holders, 1 with 1 transaction, 1 shared with 9874" 
	holder := accounts first accountHolders detect: [:each | each id = 28].
	otherHolder := accounts first accountHolders detect: [:each | each id = 27].
	self assert:  (holder transactions collect: [:each | each amount currency]) asSortedCollection asArray = #(#EUR).
	session accessor permitNothing.
	self assert: (otherHolder transactions collect: [:each | each amount currency]) asSortedCollection asArray = #(#CDN #USD).
]

{ #category : #tests }
GlorpFilteringQueryDBTest >> testReadOneToManyEmptyCriteria [
	| accounts txMapping otherHolder holder |
	(GlorpReadingTest new session: session) write2CustomerRowsWith3Transactions.
	txMapping := (system descriptorFor: GlorpCustomer) mappingForAttributeNamed: #transactions.
	txMapping useFilteredRead.
	accounts := session execute: (Query read: GlorpBankAccount).
	accounts := accounts asSortedCollection: [:a :b | a id <= b id].
	"Account 6, 2 holders, 1 with 1 transaction, 1 shared with 9874" 
	holder := accounts first accountHolders detect: [:each | each id = 28].
	otherHolder := accounts first accountHolders detect: [:each | each id = 27].
	self assert:  (holder transactions collect: [:each | each amount currency]) asSortedCollection asArray = #(#EUR).
	session accessor permitNothing.
	self assert: (otherHolder transactions collect: [:each | each amount currency]) asSortedCollection asArray = #(#CDN #USD).
]

{ #category : #tests }
GlorpFilteringQueryDBTest >> testReadOneToManyNoProxy [
	"This doesn't actually short-circuit interestingly, because of the shared holder"
	| accounts txMapping tx1 tx2 otherHolder |
	(GlorpReadingTest new session: session) write2CustomerRowsWith3Transactions.
	txMapping := (system descriptorFor: GlorpCustomer) mappingForAttributeNamed: #transactions.
	txMapping shouldProxy: false.
	txMapping useFilteredRead.
	accounts := session execute: ((Query read: GlorpBankAccount where: [:each | each id ~= 2]) orderBy: [:each | each id]).
	"Account 9874, 1 holder, 2 transactions"
	tx1 := accounts last accountHolders first transactions.
	"Account 6, 2 holders, 1 with 1 transaction, 1 shared with 9874" 
	otherHolder := accounts first accountHolders detect: [:each | each id = 28].
	tx2 := otherHolder transactions.
	self assert: (tx1 collect: [:each | each amount currency]) asSortedCollection asArray = #(#CDN #USD).
	self assert: (tx2 collect: [:each | each amount currency]) asSortedCollection asArray = #(EUR).
]

{ #category : #tests }
GlorpFilteringQueryDBTest >> testReadOneToOne [
	| people addressMapping |
	session writeRow: session system exampleAddressRowForOrdering1.
	session writeRow: session system exampleAddressRowForOrdering2.
	session writeRow: session system exampleAddressRowForOrdering3.

	session writeRow: session system examplePersonRowForOrdering1.
	session writeRow: session system examplePersonRowForOrdering2.
	session writeRow: session system examplePersonRowForOrdering3.

	addressMapping := (system descriptorFor: GlorpPerson) mappingForAttributeNamed: #address.
	addressMapping useFilteredRead.
	people := session execute: (Query read: GlorpPerson where: [:each | each id ~= 2]).
	people first address yourSelf.
	session accessor permitNothing.
	people := people asSortedCollection: [:a :b | a id <= b id].
	self assert: people first address id = 2.
	self assert: (people at: 2) address id = 3.
	self assert: (people at: 3) address id = 1.
	self assert: people size = 3.
]

{ #category : #tests }
GlorpFilteringQueryDBTest >> testTwoLevelRead [
	"A one-many and a many-many"
	| accounts txMapping otherHolder holder accountMapping |
	(GlorpReadingTest new session: session) write2CustomerRowsWith3Transactions.
	txMapping := (system descriptorFor: GlorpCustomer) mappingForAttributeNamed: #transactions.
	txMapping useFilteredRead.
	accountMapping := (system descriptorFor: GlorpBankAccount) mappingForAttributeNamed: #accountHolders.
	accountMapping useFilteredRead.
	accounts := session execute: ((Query read: GlorpBankAccount where: [:each | each id ~= 2]) orderBy: [:each | each id]).
	"Account 6, 2 holders, 1 with 1 transaction, 1 shared with 9874" 
	self assert: accounts first accountHolders size = 2.
	holder := accounts first accountHolders detect: [:each | each id = 28].
	holder transactions yourSelf.
	session accessor permitNothing.
	self assert: (accounts last accountHolders collect: [:each | each id]) asArray = #(27).
	otherHolder := accounts first accountHolders detect: [:each | each id = 27].
	self assert:  (holder transactions collect: [:each | each amount currency]) asSortedCollection asArray = #(#EUR).
	session accessor permitNothing.
	self assert: (otherHolder transactions collect: [:each | each amount currency]) asSortedCollection asArray = #(#CDN #USD).
]
