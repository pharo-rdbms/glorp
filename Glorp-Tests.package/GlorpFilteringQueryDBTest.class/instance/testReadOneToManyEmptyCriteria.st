tests
testReadOneToManyEmptyCriteria
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