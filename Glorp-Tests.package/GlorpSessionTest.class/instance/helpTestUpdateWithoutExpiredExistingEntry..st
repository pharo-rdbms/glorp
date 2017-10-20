tests
helpTestUpdateWithoutExpiredExistingEntry: aCachePolicy
	| customer2 row table unitOfWork |
	(session system descriptorFor: GlorpCustomer) 
		cachePolicy: (TimedExpiryCachePolicy new timeout: 0).
	customer2 := GlorpCustomer new.
	customer2 id: 3.
	customer2 name: 'Barney Rubble'.
	row := DatabaseRow newForTable: (table := system tableNamed: 'GR_CUSTOMER').
	row at: (table fieldNamed: 'ID') put: 3.
	unitOfWork := UnitOfWork new.
	unitOfWork session: session.
	unitOfWork updateSessionCacheFor: customer2 withRow: row.
	self assert: (session expiredInstanceOf: GlorpCustomer key: 3) == customer2.