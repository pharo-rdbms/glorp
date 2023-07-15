"
A command to insert our set of rows.
"
Class {
	#name : #InsertCommand,
	#superclass : #RowBasedCommand,
	#category : #'Glorp-Database'
}

{ #category : #accessing }
InsertCommand >> arrayBoundFields [
	"For array binding, include all the fields, except if we're inserting into a database with identity columns, where we must omit those columns"

	^ self platform usesIdentityColumns
		  ifTrue: [
		  row table fields reject: [ :each | each type isIdentityColumn ] ]
		  ifFalse: [ row table fields ]
]

{ #category : #accessing }
InsertCommand >> basicPrintSQLFor: aRow [

	| fields |
	self nextPutAll: 'INSERT INTO '.
	aRow table printSQLOn: self withParameters: #().
	fields := self shouldUseGroupWriting
		ifTrue: [self arrayBoundFields]
		ifFalse: [aRow nonGeneratedFieldsWithValues].
	self nextPutAll: ' ('.
	GlorpHelper
		do: [:each | self nextPutAll: (self platform nameForColumn: each name)]
		for: fields
		separatedBy: [self nextPutAll: ','].
	self nextPutAll: ') '.
	self nextPutAll: ' VALUES ('.
	GlorpHelper
		do:
			[:each |
			(self canBind: (aRow at: each ifAbsent: [nil]) to: each type)
				ifTrue: [self nextPut: $?]
				ifFalse: [aRow printValueOfField: each on: self]]
		for: fields
		separatedBy: [self nextPutAll: ','].
	self nextPutAll: ')'
]

{ #category : #'bound values' }
InsertCommand >> bindingTypes [
	| all basic size |
	^(self shouldUseGroupWriting)
		ifTrue: [
			basic := self arrayBoundFields collect: [:each | each type].
			size := basic size.
			all := Array new: (allRows size * size).
			0 to: allRows size - 1 do: [:i |
				| index |
				index := i * size.
				all replaceElementsFrom: index + 1 to: index + size withArray: basic startingAt: 1].
			all]
		ifFalse: [self singleRowBoundFields collect: [:each | each type]].
]

{ #category : #printing }
InsertCommand >> printSQL [

	| iterations |
	iterations := self shouldUseGroupWriting
		              ifTrue: [
			              self platform usesArrayBindingRatherThanGroupWriting
				              ifTrue: [ 1 ]
				              ifFalse: [ allRows size ] ]
		              ifFalse: [ 1 ].
	GlorpHelper
		do: [ :i |
			self basicPrintSQLFor: (i = 1
					 ifTrue: [ row ]
					 ifFalse: [ allRows at: i ]) ]
		for: (1 to: iterations)
		separatedBy: [ self nextPutAll: '; ' ]
]

{ #category : #'bound values' }
InsertCommand >> singleRowBoundFields [
	"Include only the fields that have values in our particular row"

	^ row nonGeneratedFieldsWithValues
]

{ #category : #testing }
InsertCommand >> supportsGroupWriting [

	^ true
]
