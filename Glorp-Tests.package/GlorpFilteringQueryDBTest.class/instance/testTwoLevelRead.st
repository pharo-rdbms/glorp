tests
testTwoLevelRead
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