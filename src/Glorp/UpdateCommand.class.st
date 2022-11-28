"
A command to update our set of rows.
"
Class {
	#name : #UpdateCommand,
	#superclass : #RowBasedCommand,
	#category : 'Glorp-Database'
}

{ #category : #accessing }
UpdateCommand >> arrayBindings [
	"I don't think we can array bind updates. There may be values in the row that we haven't read, and if we attempt to write all the fields we'll be overwriting them with nulls. It's possible that there's a set of rows with all the same fields and we could update them all the same way, but that isn't done yet"
	self error: 'cannot array bind an update'.
]

{ #category : #accessing }
UpdateCommand >> arrayBoundFields [
	^row table nonPrimaryKeyFields asArray , row table primaryKeyFields asArray.
]

{ #category : #'bound values' }
UpdateCommand >> bindingTypes [
	^super bindingTypes, (row lockKeyFields collect: [:each | each type]).
]

{ #category : #accessing }
UpdateCommand >> blockFactor [
	^1.
]

{ #category : #accessing }
UpdateCommand >> fieldsNeedingUpdate [
	^self shouldUpdateOnlyChangedFields 
		ifTrue: [row fieldsNeedingUpdate]
		ifFalse: [row nonPrimaryKeyFields]
]

{ #category : #accessing }
UpdateCommand >> needsRowCount [
	^row lockKeyFields isEmpty not.
]

{ #category : #printing }
UpdateCommand >> printSQL [
	| bodyFields |
	self nextPutAll: 'UPDATE '.
	row table printSQLOn: self withParameters: #().
	self nextPutAll: ' SET '.
	bodyFields := self fieldsNeedingUpdate.
	GlorpHelper 
		do: [:field | row printEqualityTemplateForField: field on: self]
		for: bodyFields
		separatedBy: [self nextPut: $,].
	self nextPutAll: ' WHERE '.
	row printPrimaryKeyTemplateOn: self.
	row lockKeyFields notEmpty
		ifTrue: 
			[self nextPutAll: ' AND '.
			GlorpHelper
				do: [:field | row printLockEqualityForField: field on: self]
				for: row lockKeyFields
				separatedBy: [self nextPutAll: ' AND ']]
]

{ #category : #testing }
UpdateCommand >> shouldUpdateOnlyChangedFields [
	"Return true if we should write only changed fields out in an update statement, or if we should write all of them. The tradeoff is that writing only the changed ones will produce less SQL, but make more variations of the statement, and require us to keep more prepared statements around if we're using binding. By default, use this option only if we're not using binding by default. It would be nice if we could delegate this decision to somewhere the user has control over, e.g. the descriptor system, but we don't actually know about it"
	^self system shouldUpdateOnlyChangedFieldsFor: self.
]

{ #category : #'bound values' }
UpdateCommand >> singleRowBindings [
	"Whether binding or not, my printSQL method writes IS NULL if a lock field's value is nil since, in the where clause, the SQL must be WHERE ... IS NULL, not WHERE ... =NULL, and so at the least must not be offered as WHERE ... =? VALUES(..., nil) to PostgreSQL sockets.
	The lock fields come last, so if there is only one lock field then its final nil binding value can be provided for a lower layer to ignore, as was done in older Glorp.  However if there are two lock fields (rarer case), the nil value for the first gets bound to the second's ? in the SQL, its own value being ignored.  Therefore I must not bind nil to a lock field.
	An UpdateCommand cannot be arrayBound and returns false to supportsGroupWriting, so this is the only method where we have to handle lock fields."



	| basic lockFields lockValues |
	basic := super singleRowBindings.
	lockFields := row lockKeyFields.
	lockFields isEmpty ifTrue: [^basic].
	lockValues := OrderedCollection new: 2.
	lockFields do:
		[:each || fieldValue | fieldValue := row oldVersionAt: each ifAbsent: [nil].
		(fieldValue notNil and: [self canBind: fieldValue to: each type]) ifTrue:
			[lockValues add: fieldValue]].
	^basic, lockValues
]

{ #category : #'bound values' }
UpdateCommand >> singleRowBoundFields [
	"Note: We will actually have to bind one more thing than this, the optimistic lock fields (if present). That's handled in the caller"
	| basicFields |
	basicFields := self fieldsNeedingUpdate.
	^basicFields , row table primaryKeyFields asArray
]
