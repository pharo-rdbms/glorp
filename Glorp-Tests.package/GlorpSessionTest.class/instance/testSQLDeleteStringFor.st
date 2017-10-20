tests
testSQLDeleteStringFor
	| row table string |
	table := session system tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'ID') put: 12.
	row at: (table fieldNamed: 'STREET') put: 'some street'.
	string := (DeleteCommand forRow: row useBinding: true session: session) sqlString.
	self assert: string = 'DELETE FROM GR_ADDRESS WHERE ID = ?'.
	string := (DeleteCommand forRow: row useBinding: false session: session) sqlString.
	self assert: string = 'DELETE FROM GR_ADDRESS WHERE ID = 12'.