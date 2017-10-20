tests
testWrite
	"Write and validate that it basically got written correctly, in terms of number and keys of db rows"

	| storeRows storeRow purchaseRows purchaseKeys rentalRows rentalKeys |
	storeRows := session accessor
		executeSQLString: 'SELECT * FROM VIDEO_STORE'.
	storeRows := storeRows asSortedCollection: [:a :b | a first <= b first].
	self assert: storeRows size = 2.
	storeRow := storeRows first.
	self assert: storeRow size = 2.
	self assert: storeRow first = 1.
	self assert: storeRow last = 'Als Video'.
	storeRow := storeRows last.
	self assert: storeRow first = 2.
	self assert: storeRow last = 'Bonzai Video'.
	purchaseRows := session accessor
		executeSQLString: 'SELECT * FROM VIDEO_PURCHASE'.
	self assert: purchaseRows size = 10.
	purchaseKeys := (purchaseRows collect: [:each | each atIndex: 1])
		asSortedCollection.
	self assert: purchaseKeys asArray = #(1 2 3 101 102 103 104 105 106 107).
	rentalRows := session accessor
		executeSQLString: 'SELECT * FROM VIDEO_RENTAL'.
	self assert: rentalRows size = 4.
	rentalKeys := (rentalRows collect: [:each | each atIndex: 1])
		asSortedCollection.
	self assert: rentalKeys asArray = #(1001 1002 1003 1004).