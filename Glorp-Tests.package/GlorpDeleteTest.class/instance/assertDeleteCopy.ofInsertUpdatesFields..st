delete-insert-update tests
assertDeleteCopy: aBlock ofInsertUpdatesFields: anInteger
	"If the test is run bound then #shouldUpdateOnlyChangedFields will by default return false and all 3 fields will be updated regardless of which have been changed.  We therefore check the row's opinion of fieldsNeedingUpdate, not the UpdateCommand's opinion."

	| person oldAddress address otherSession triedToWrite |
	person := GlorpPerson example2.
	person address: nil.
	[address := self setUpPersonWithAddress address getValue.
	oldAddress := aBlock value: address.
	address street: 'Change Street'.
	otherSession := GlorpDemoDescriptorSystem sessionForLogin: GlorpDatabaseLoginResource current login.
	otherSession  accessor: GlorpDatabaseLoginResource current accessor.
	otherSession accessor denyWrites.
	otherSession beginUnitOfWork.
	otherSession delete: oldAddress.
	person address: address.
	otherSession register: person.
	[otherSession commitUnitOfWork] on: GlorpIllegalCommand do:
		[:ex || rowMap row | triedToWrite := true.
		rowMap := otherSession privateGetCurrentUnitOfWork privateGetRowMap
			subMapForTable: (otherSession system tableNamed: 'GR_ADDRESS').
		row := rowMap at: address.
		self deny: row forDeletion.
		self assert: row fieldsNeedingUpdate size = anInteger.
		row := rowMap at: oldAddress.
		self assert: row forDeletion]] ensure:
			[session rollbackTransaction.
			otherSession rollbackTransaction.
			otherSession resetPermissions].
	self assert: triedToWrite.