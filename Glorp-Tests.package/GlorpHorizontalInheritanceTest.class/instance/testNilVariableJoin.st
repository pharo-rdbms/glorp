tests
testNilVariableJoin
	| warehouse |
	self writeTestHarness.
	warehouse := session readOneOf: GlorpWarehouse
				where: [:each | each address = '123 Some Ave.'].
	session beginUnitOfWork.
	session register: warehouse.
	warehouse currentItem: nil.
	session commitUnitOfWork.
	session reset.
	warehouse := session readOneOf: GlorpWarehouse
				where: [:each | each address = '123 Some Ave.'].
	self assert: warehouse currentItem isNil