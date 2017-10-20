tests
testReadAdHocProxied
	| table row time idField times time2 |
	((session system descriptorFor: GlorpTransformedTime) mappingForAttributeNamed: #time) shouldProxy: true.
	[
	session beginTransaction.
	
	table := session system tableNamed: 'TRANSFORMED_TIME'.
	row := DatabaseRow newForTable: table.
	idField := (table fieldNamed: 'ID').
	row at: idField put: 3.
	time := Time now.
	row at: (table fieldNamed: 'TIMEFIELD') put: time asSeconds.
	session writeRow: row.

	row := DatabaseRow newForTable: table.
	row at: idField put: 4.
	time2 := Dialect addSeconds: 10 to: Time now.
	row at: (table fieldNamed: 'TIMEFIELD') put: time2 asSeconds.
	session writeRow: row.

	times := session read: GlorpTransformedTime orderBy: [:each | each time].
	self assert: times size = 2.
	self assert: times first time class == AdHocProxy.
	self assert: times first time asSeconds = time asSeconds.
	self assert: times last time asSeconds = time2 asSeconds.
	] 
			ensure: [session rollbackTransaction]