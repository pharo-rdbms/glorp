"
This is a sequence that just does a select max(primaryKeyFieldName) for the table in question and adds one to it. This is, um, less-than-perfectly efficient, and I'm not at all clear that it'll work for a multi-user system. But it's what Store used to do on SQL Server, so we'd like to be able to mimic it. And it's actually easier to preallocate for than identity columns, which is nice. This isn't really named in the same sense as the others, but it's useful to inherit the named preallocation behaviour, and we store the field to select against in the name.

Instance Variables:
	tableName	<DatabaseTable>	the table we sequence.
	field <DatabaseField> the field we sequence.
"
Class {
	#name : 'JustSelectTheMaximumSequenceValueAndAddOne',
	#superclass : 'NamedSequence',
	#instVars : [
		'field',
		'table'
	],
	#category : 'Glorp-Database',
	#package : 'Glorp',
	#tag : 'Database'
}

{ #category : 'accessing' }
JustSelectTheMaximumSequenceValueAndAddOne >> field [

	field ifNil: [ field := table primaryKeyFields first ].
	^ field
]

{ #category : 'accessing' }
JustSelectTheMaximumSequenceValueAndAddOne >> field: aDatabaseField [

	field := aDatabaseField
]

{ #category : 'sequencing' }
JustSelectTheMaximumSequenceValueAndAddOne >> getSequenceValueFromDatabaseFor: aField in: aRow using: aSession [

	| stream rows value |
	"I repeat: ick"
	stream := WriteStream on: (String new: 50).
	stream nextPutAll: 'SELECT MAX('.
	aField printSQLOn: stream withParameters: #(  ).
	stream nextPutAll: ') FROM '.
	aRow table printSQLOn: stream withParameters: #(  ).
	rows := aSession accessor executeSQLString: stream contents.
	value := rows first first
		         ifNil: [ 1 ]
		         ifNotNil: [ rows first first + 1 ].
	aRow at: aField put: value.
	^ value
]

{ #category : 'sequencing' }
JustSelectTheMaximumSequenceValueAndAddOne >> reserveSequenceNumbers: anInteger in: anAccessor for: aTable [

	| numberNeeded firstNumber fakeRow |
	numberNeeded := anInteger - self availableReservedNumbers.
	numberNeeded <= 0 ifTrue: [^self].
	fakeRow := DatabaseRow newForTable: self field table.
	firstNumber := self
		getSequenceValueFromDatabaseFor: self field
		in: fakeRow
		using: anAccessor.
	self reservedNumbers addAll: (firstNumber to: firstNumber + numberNeeded - 1)
]

{ #category : 'accessing' }
JustSelectTheMaximumSequenceValueAndAddOne >> table: aTable [

	table := aTable
]
