tests
testReadBackAllCustomer
	| customers |
	customers := session read: GlorpVideoCustomer.
	self assert: ((customers collect: [:each | each name]) asSortedCollection asArray) = #('Adrian' 'Bob' 'Carol' 'David' 'Eleanor' 'Francois' 'George' 'Hieronymous').