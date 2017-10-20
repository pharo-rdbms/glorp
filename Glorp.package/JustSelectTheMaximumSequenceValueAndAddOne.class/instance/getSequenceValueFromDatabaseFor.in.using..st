other
getSequenceValueFromDatabaseFor: aField in: aRow using: aSession

	| stream rows value |
	"I repeat: ick"
	stream := WriteStream on: (String new: 50).
	stream nextPutAll: 'SELECT MAX('.
	aField printSQLOn: stream withParameters: #().
	stream nextPutAll: ') FROM '.
	aRow table printSQLOn: stream withParameters: #().
	rows := aSession accessor executeSQLString: stream contents.
	value := rows first first isNil ifTrue: [1] ifFalse: [rows first first + 1].
	aRow at: aField put: value.
	^value.