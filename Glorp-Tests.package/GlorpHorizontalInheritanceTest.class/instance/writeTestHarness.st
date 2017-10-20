support
writeTestHarness

	| squash apples fridge bicycle warehouse |
	session inUnitOfWorkDo: [
	session register: (squash := GlorpPerishableItem new id: 1; name: 'squash'; age: 10; yourself).
	session register: (GlorpPerishableItem new id: 2; name: 'zucchini'; age: 14; yourself).
	session register: (apples := GlorpPerishableItem new id: 3; name: 'apples'; age: 4; yourself).
	session register: (GlorpNonperishableItem new id: 4; name: 'TV'; serialNumber: 56893; yourself).
	session register: (fridge := GlorpNonperishableItem new id: 5; name: 'fridge'; serialNumber: 12345; yourself).
	session register: (bicycle := GlorpUnassembledItem new id: 6; name: 'bicycle'; serialNumber: 83754; assemblyCost: 100; yourself).
	session register: (GlorpUnassembledItem new id: 7; name: 'wagon'; serialNumber: 99958; assemblyCost: 20; yourself).
	warehouse := GlorpWarehouse new.
	warehouse address: '123 Some Ave.'.
	warehouse currentItem: squash.
	warehouse items: (Array with: apples with: fridge with: bicycle).
	session register: warehouse].
	session reset.