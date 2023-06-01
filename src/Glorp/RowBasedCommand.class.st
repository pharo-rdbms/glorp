"
This is a command based on one or more in-memory rows. The purposes is to write, or delete that row or rows. This knows enough to be able to use features like array binding to do the row operations more efficiently.

Subclasses must implement the following messages:
	bound values
		arrayBoundFields
		singleRowBoundFields

Instance Variables:
	allRows	<(Collection of: (DatabaseRow))> A collection of rows. May be nil. If we have multiples, then we will be array bound or otherwise bulk-written under certain circumstances.
	row	<DatabaseRow>	The primary row, either the single row we're writing, or the one we're writing right now out of the allRows collection.
	rowCount	<Integer>	The row count from the last statement we executed.
	succeeded	<Boolean>	Has the statement overall succeded or failed.


"
Class {
	#name : #RowBasedCommand,
	#superclass : #DatabaseCommand,
	#instVars : [
		'row',
		'allRows',
		'rowCount',
		'failed'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
RowBasedCommand class >> forRow: aDatabaseRow useBinding: aBoolean session: aSession [

	^ self new
		  row: aDatabaseRow;
		  useBinding: aBoolean;
		  session: aSession;
		  yourself
]

{ #category : #'*Glorp' }
RowBasedCommand class >> forRows: aCollectionOfDatabaseRows useBinding: aBoolean session: aSession [

	^ self new
		  allRows: aCollectionOfDatabaseRows;
		  row: aCollectionOfDatabaseRows first;
		  useBinding: aBoolean;
		  session: aSession;
		  yourself
]

{ #category : #accessing }
RowBasedCommand >> allRows [

	^ allRows
]

{ #category : #accessing }
RowBasedCommand >> allRows: aCollectionOfDatabaseRows [

	allRows := aCollectionOfDatabaseRows
]

{ #category : #'bound values' }
RowBasedCommand >> arrayBindings [
	"Return bindings in a form suitable for Oracle array binding, i.e. a list of arguments, but each argument is itself a list of multiple values"
	| allBindings fields |
	fields := self arrayBoundFields.
	allBindings := (1 to: fields size)
		collect: [:each | Array new: allRows size].
	1
		to: allRows size
		do:
			[:rowNumber |
			| inputRow |
			inputRow := allRows at: rowNumber.
			1
				to: fields size
				do:
					[:columnNumber |
					(allBindings at: columnNumber)
						at: rowNumber
						put: (inputRow at: (fields at: columnNumber) ifAbsent: [nil])]].
	^allBindings asArray
]

{ #category : #accessing }
RowBasedCommand >> arrayBoundFields [
	"Return the list of fields to be bound in the SQL string we will use for array binding. For array binding, we need to include all possible fields, rather than those that just have values in a particular row"

	self subclassResponsibility
]

{ #category : #'bound values' }
RowBasedCommand >> batchStatementBindings [
	"Return our bindings, which we assume are for multiple rows, as one big array, one statement after the other"

	| bound fields |
	fields := self arrayBoundFields.
	bound := OrderedCollection new: allRows size * fields size.
	allRows do: [:eachRow |
		fields do: [:each |
			| fieldValue |
			fieldValue := eachRow at: each ifAbsent: [nil].
			(self canBind: fieldValue to: each type) ifTrue: [bound add: fieldValue]]].
	^bound asArray
]

{ #category : #accessing }
RowBasedCommand >> bindingTypes [
	| all basic size |
	^(self shouldUseGroupWriting)
		ifTrue: [
			basic := self row nonGeneratedFields collect: [:each | each type].
			size := basic size.
			all := Array new: (allRows size * size).
			0 to: allRows size - 1 do: [:i |
				| index |
				index := i * size.
				all replaceElementsFrom: index + 1 to: index + size withArray: basic startingAt: 1].
			all]
		ifFalse: [self singleRowBoundFields collect: [:each | each type]]
]

{ #category : #accessing }
RowBasedCommand >> bindings [

	^ self shouldUseGroupWriting
		  ifTrue: [ self platform bindingsForGroupWritingFor: self ]
		  ifFalse: [ self singleRowBindings ]
]

{ #category : #executing }
RowBasedCommand >> executeBoundIn: anAccessor [

	| result |
	(self hasMultipleRows and: [self shouldUseGroupWriting not])
		ifTrue:
			[self allRows
				do:
					[:each |
					self row: each.
					result := anAccessor executeCommandBound: self.
					result release.
					failed := failed or: [self needsRowCount and: [rowCount ~= 1]].
					each postWriteAssignSequencesUsing: anAccessor]]
		ifFalse:
			[result := anAccessor executeCommandBound: self.
			result release.
			failed := self needsRowCount and: [rowCount ~= self expectedNumberOfModifiedRows].
			row postWriteAssignSequencesUsing: anAccessor].
	"Results aren't interesting"
	^ anAccessor cursorFor: #() readStream
]

{ #category : #executing }
RowBasedCommand >> executeUnboundIn: anAccessor [
	anAccessor returnRowCount: self needsRowCount.
	(self hasMultipleRows and: [self shouldUseGroupWriting not])
		ifTrue:
			[self allRows
				do:
					[:each |
					self row: each.
					anAccessor
						executeSQLStringNoResult: self sqlString
						doing:
							[failed := failed or: [self needsRowCount and: [anAccessor rowCount ~= 1]]]
						forCommand: self.
					each postWriteAssignSequencesUsing: anAccessor]]
		ifFalse:
			[self tooBigForSingleWrite
				ifTrue:
					[self subCommands do: [:each | each executeUnboundIn: anAccessor]]
				ifFalse:
					[anAccessor
						executeSQLStringNoResult: self sqlString
						doing:
							[failed := self needsRowCount
								and: [anAccessor rowCount ~= self expectedNumberOfModifiedRows]]
						forCommand: self].
			row postWriteAssignSequencesUsing: anAccessor].
	^#() readStream
]

{ #category : #executing }
RowBasedCommand >> expectedNumberOfModifiedRows [

	^ self hasMultipleRows
		  ifTrue: [ allRows size ]
		  ifFalse: [ 1 ]
]

{ #category : #testing }
RowBasedCommand >> hasMultipleRows [

	^ allRows notNil and: [ allRows size > 1 ]
]

{ #category : #initialization }
RowBasedCommand >> initialize [

	super initialize.
	failed := false
]

{ #category : #testing }
RowBasedCommand >> maximumSingleWriteSize [
	"How many values will write at once. This is only really applicable when not doing binding and concatenating many statements together for one trip to the DB"

	^ 1000
]

{ #category : #accessing }
RowBasedCommand >> parameterTypeSignature [
	"Return a string indicating the parameter types. Complicated by the possibility of multiple rows, and of null values"

	| result |
	result := WriteStream on: String new.
	self hasMultipleRows
		ifTrue: [
			row keysAndValuesDo: [ :eachKey :eachValInFirstRow |
				| nextValue |
				eachValInFirstRow notNil
					ifTrue: [ result nextPutAll: eachValInFirstRow class name ]
					ifFalse: [
						allRows do: [ :eachRow |
							(nextValue := eachRow at: eachKey ifAbsent: [ nil ]) notNil
								ifTrue: [ result nextPutAll: nextValue class name ] ] ] ] ]
		ifFalse: [
			row keysAndValuesDo: [ :eachKey :eachValue |
				result nextPutAll: eachValue class name ] ].
	^ result contents
]

{ #category : #accessing }
RowBasedCommand >> row [

	^ row
]

{ #category : #accessing }
RowBasedCommand >> row: anObject [

	row := anObject.
	sqlString := nil
]

{ #category : #'bound values' }
RowBasedCommand >> rowAtATimeBindings [
	"Return multiple sets of bindings in a form suitable for iterating over"

	| allBindings fields rowTemplate |
	fields := self arrayBoundFields.
	rowTemplate := Array new: fields size.
	allBindings := Array new: allRows size.
	1 to: allBindings size do: [:i | | currentRow input |
		currentRow := rowTemplate copy.
		input := allRows at: i.
		allBindings at: i put: currentRow.
		1 to: fields size do: [:j |
			currentRow at: j put: (input at: (fields at: j) ifAbsent: [nil])]].
	^allBindings asArray
]

{ #category : #accessing }
RowBasedCommand >> rowCount [

	^ rowCount
]

{ #category : #accessing }
RowBasedCommand >> rowCount: anInteger [

	rowCount := anInteger
]

{ #category : #'bound values' }
RowBasedCommand >> singleRowBindings [

	| bound |
	bound := OrderedCollection new.
	self singleRowBoundFields do: [ :each |
		| fieldValue |
		fieldValue := row at: each ifAbsent: [ nil ].
		(self canBind: fieldValue to: each type) ifTrue: [
			bound add: fieldValue ] ].
	^ bound asArray
]

{ #category : #'bound values' }
RowBasedCommand >> singleRowBoundFields [
	"Return the list of fields to be bound in the SQL string we will use for a single operation. We only need to include those fields that actually have values in the particular row we're operating on"

	self subclassResponsibility
]

{ #category : #executing }
RowBasedCommand >> subCommands [

	| startPosition commands endPosition subRows newCommand |
	startPosition := 1.
	commands := OrderedCollection new.
	[ startPosition > allRows size ] whileFalse: [
		endPosition := startPosition + self maximumSingleWriteSize - 1 min:
			               allRows size.
		subRows := allRows copyFrom: startPosition to: endPosition.
		newCommand := self class
			              forRows: subRows
			              useBinding: self useBinding
			              session: self session.
		commands add: newCommand.
		startPosition := endPosition + 1 ].
	^ commands
]

{ #category : #testing }
RowBasedCommand >> succeeded [

	^ failed not
]

{ #category : #testing }
RowBasedCommand >> supportsGroupWriting [
	"Return true if array binding or a similar mechanism can be used to execute us with multiple commands at once. I think in general this can only ever make sense for inserts (and possibly selects under some circumstances). Updates may want to update only part of the fields."

	^ false
]

{ #category : #reporting }
RowBasedCommand >> tables [

	^ Array with: self row table
]

{ #category : #testing }
RowBasedCommand >> tooBigForSingleWrite [

	^ self hasMultipleRows and: [
		  allRows size > self maximumSingleWriteSize ]
]
