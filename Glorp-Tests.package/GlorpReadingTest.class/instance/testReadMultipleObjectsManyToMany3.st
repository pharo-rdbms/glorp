tests
testReadMultipleObjectsManyToMany3
	| query result customer array |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpCustomer.
	query retrieve: [:each | each ].
	query retrieve: [:each | each accounts].
	result := query executeIn: session.
	self assert: result size = 1.
	array := result first.
	customer := array first.
	self deny: customer accounts isGlorpProxy.
	self assert: customer accounts size = 2.
	self assert: customer accounts == array last] 
			ensure: [session rollbackTransaction]