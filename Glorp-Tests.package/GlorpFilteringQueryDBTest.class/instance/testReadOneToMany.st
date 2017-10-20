tests
testReadOneToMany
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