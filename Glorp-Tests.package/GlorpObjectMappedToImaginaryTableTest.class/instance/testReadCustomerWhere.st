tests
testReadCustomerWhere
	| customers |
	customers := session read: GlorpVideoCustomer where: [:each | each name like: '%an%'].
	self assert: ((customers collect: [:each | each name]) asSortedCollection asArray) = #('Adrian'  'Eleanor' 'Francois').