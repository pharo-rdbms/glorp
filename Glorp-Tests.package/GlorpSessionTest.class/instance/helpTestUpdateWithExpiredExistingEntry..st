tests
helpTestUpdateWithExpiredExistingEntry: aCachePolicy
	| customer customer2 row table unitOfWork |
	(session system descriptorFor: GlorpCustomer) 
		cachePolicy: aCachePolicy.
	customer := self addCustomerToCache.
	customer2 := GlorpCustomer new.
	customer2 id: customer id.
	customer2 name: 'Barney Rubble'.
	row := DatabaseRow newForTable: (table := system tableNamed: 'GR_CUSTOMER').
	row at: (table fieldNamed: 'ID') put: customer id.
	unitOfWork := UnitOfWork new.
	unitOfWork session: session.
	"Since there's already an object there, this shouldn't do anything"
	unitOfWork updateSessionCacheFor: customer2 withRow: row.
	self assert: (session expiredInstanceOf: GlorpCustomer key: 3) == customer.