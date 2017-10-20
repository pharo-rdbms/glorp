tests
testReadCustomerWhereWithJoin
	| customers |
	customers := session read: GlorpVideoCustomer where: [:each | each onlinePurchases anySatisfy: [:eachPurchase | eachPurchase price > 2]].
	self assert: ((customers collect: [:each | each name]) asSortedCollection asArray) = #('Adrian'  'George' ).