tests
testFieldsToUpdate

	| command system row old bookTable session |
	session := GlorpLockingDescriptorSystem sessionForLogin: (Login new database: OraclePlatform new).
	system := session system.
	bookTable := system tableNamed: 'BOOK'.
	row := DatabaseRow newForTable: bookTable.
	old := DatabaseRow newForTable: bookTable.
	old at: (bookTable fieldNamed: 'ID') put: 6.
	old at: (bookTable fieldNamed: 'TITLE') put: 'ABook'.
	old at: (bookTable fieldNamed: 'DESCRIPTION') put: 'Stuff'.
	old at: (bookTable fieldNamed: 'COPIES_IN_STOCK') put: 3.
	old at: (bookTable fieldNamed: 'VERSION') put: 2.

	row at: (bookTable fieldNamed: 'ID') put: 6.
	row at: (bookTable fieldNamed: 'TITLE') put: 'ABook'.
	row at: (bookTable fieldNamed: 'DESCRIPTION') put: 'Stuff'.
	row at: (bookTable fieldNamed: 'COPIES_IN_STOCK') put: 4.
	row at: (bookTable fieldNamed: 'VERSION') put: 2.
	row withAllFieldsIn: old.
	command := UpdateCommand forRows: (Array with: row) useBinding: false session: session.
	self assert: command shouldUpdateOnlyChangedFields.
	self assert: command singleRowBoundFields size = 2.
	self assert: command singleRowBindings isEmpty. 
	command useBinding: true.
	self deny: command shouldUpdateOnlyChangedFields.
	self assert: command singleRowBoundFields size = 5.
	"The lock field is bound at the end"
	self assert: command singleRowBindings size = 6.