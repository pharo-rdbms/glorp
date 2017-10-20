support
readCustomer: aCustomerId
	| results query |
	query := Query
		read: GlorpCustomer
		where: [:cust | cust id = aCustomerId].
	results := query executeIn: session.
	self assert: results size = 1.
	^results first.