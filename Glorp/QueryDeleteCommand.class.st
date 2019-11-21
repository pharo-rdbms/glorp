"
This represent a query that does a delete with a where clause

Instance Variables
	query	<SimpleQuery>	The query that holds our where clause.


"
Class {
	#name : #QueryDeleteCommand,
	#superclass : #SelectCommand,
	#instVars : [
		'query',
		'rowCount'
	],
	#category : 'Glorp-Database'
}

{ #category : #accessing }
QueryDeleteCommand >> bindingTypes [
	^#().
]

{ #category : #accessing }
QueryDeleteCommand >> bindings [
	^#().
]

{ #category : #executing }
QueryDeleteCommand >> executeUnboundIn: anAccessor [
	anAccessor returnRowCount: true.
	anAccessor
		executeSQLStringNoResult: self sqlString
			doing: [self rowCount: anAccessor rowCount]
			forCommand: self.
	session platform supportsRowCount ifFalse: [self rowCount: nil   "Make sure it's clearly not a valid value"].
	^#() readStream.
]

{ #category : #testing }
QueryDeleteCommand >> isDeleteCommand [

	^true
]

{ #category : #testing }
QueryDeleteCommand >> needsRowCount [
	^true.
]

{ #category : #accessing }
QueryDeleteCommand >> printSQL [
	stream nextPutAll: 'DELETE '.
	query printUnqualifiedTablesOn: self.
	query printUnqualifiedWhereClauseOn: self.
]

{ #category : #accessing }
QueryDeleteCommand >> query [

	^query
]

{ #category : #accessing }
QueryDeleteCommand >> query: anObject [

	query := anObject
]

{ #category : #accessing }
QueryDeleteCommand >> rowCount [

	^rowCount
]

{ #category : #accessing }
QueryDeleteCommand >> rowCount: anInteger [

	rowCount := anInteger
]

{ #category : #reporting }
QueryDeleteCommand >> tables [
	^(self query tablesToPrint collect: [:each | each parent]) asSet.
]

{ #category : #accessing }
QueryDeleteCommand >> useBinding [
	"For simplicity, just don't use binding here to start with"
	^false.
]
