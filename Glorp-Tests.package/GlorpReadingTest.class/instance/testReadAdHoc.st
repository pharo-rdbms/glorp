tests
testReadAdHoc 
	| queryTime table row time idField times |
	
	[
	session beginTransaction.
	
	table := session system tableNamed: 'TRANSFORMED_TIME'.
	row := DatabaseRow newForTable: table.
	idField := (table fieldNamed: 'ID').
	row at: idField put: 3.
	time := Time now.
	row at: (table fieldNamed: 'TIMEFIELD') put: time asSeconds.

	session writeRow: row.
	queryTime := GlorpTransformedTime  new id: 3; time: time.
	times := session read: GlorpTransformedTime where: [:each | each time = time].
	self assert: times size = 1.
	self assert: times first time asSeconds = time asSeconds.
	] 
			ensure: [session rollbackTransaction]