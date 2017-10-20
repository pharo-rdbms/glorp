tests
testRollbackRemovesData
	"Just to make sure I'm not losing my mind"
	| numAddresses newNumAddresses|
	numAddresses := (self accessor executeSQLString: 'SELECT * FROM GR_ADDRESS') size.
	self accessor beginTransaction.
	self accessor executeSQLStringNoResult: 'INSERT INTO GR_ADDRESS (ID,STREET,HOUSE_NUM)  VALUES (111,''Main Street'',''77777'')'.
	newNumAddresses := (self accessor executeSQLString: 'SELECT * FROM GR_ADDRESS') size.
	self assert: newNumAddresses = (numAddresses + 1).
	self accessor rollbackTransaction.
	self assert: numAddresses = (self accessor executeSQLString: 'SELECT * FROM GR_ADDRESS') size.