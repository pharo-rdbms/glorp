"
A command to delete our set of rows.
"
Class {
	#name : #DeleteCommand,
	#superclass : #RowBasedCommand,
	#category : #'Glorp-Database'
}

{ #category : #accessing }
DeleteCommand >> arrayBoundFields [
	"For a delete, it makes no difference, we only ever include the primary key fields"

	^ self singleRowBoundFields
]

{ #category : #accessing }
DeleteCommand >> blockFactor [

	^ 1
]

{ #category : #printing }
DeleteCommand >> printSQL [

	self nextPutAll: 'DELETE FROM '.
	row table printSQLOn: self withParameters: #(  ).
	self nextPutAll: ' WHERE '.
	row printPrimaryKeyTemplateOn: self
]

{ #category : #accessing }
DeleteCommand >> singleRowBoundFields [
	| fields |
	fields := row table primaryKeyFields.
	fields isEmpty ifTrue: [fields := row fields].
	^fields asArray
]
