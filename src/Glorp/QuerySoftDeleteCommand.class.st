"
This represent a query that does a bulk update with a where clause

Instance Variables
	query	<SimpleQuery>	The query that holds our where clause.
"
Class {
	#name : #QuerySoftDeleteCommand,
	#superclass : #QueryDeleteCommand,
	#category : #'Glorp-Database'
}

{ #category : #accessing }
QuerySoftDeleteCommand >> bindingTypes [
	^#().
]

{ #category : #accessing }
QuerySoftDeleteCommand >> bindings [
	^#().
]

{ #category : #executing }
QuerySoftDeleteCommand >> executeUnboundIn: anAccessor [
	anAccessor returnRowCount: true.
	anAccessor
		executeSQLStringNoResult: self sqlString
			doing: [self rowCount: anAccessor rowCount]
			forCommand: self.
	session platform supportsRowCount ifFalse: [self rowCount: nil   "Make sure it's clearly not a valid value"].
	^#() readStream.
]

{ #category : #testing }
QuerySoftDeleteCommand >> isDeleteCommand [

	^true
]

{ #category : #testing }
QuerySoftDeleteCommand >> needsRowCount [
	^true.
]

{ #category : #accessing }
QuerySoftDeleteCommand >> printSQL [
	| updates updateClause now |
	now := DateAndTime now.
	updates := query tablesToPrint anyOne fields select: [ :ea | #(updated_at deleted_at) includes: ea name ].
	updateClause := (updates collect: [ :ea | 
		String streamContents: [:s | s 
			nextPutAll: ea name; 
			nextPutAll: ' = '.
			query platform timestamp print: now on: s ] ]) joinUsing: ', '.
	self nextPutAll: 'UPDATE '.
	query printUnqualifiedNormalTablesOn: self.
	self nextPutAll: ' SET '.
	self nextPutAll: updateClause.
	query printUnqualifiedWhereClauseOn: self.
]

{ #category : #reporting }
QuerySoftDeleteCommand >> tables [
	^(self query tablesToPrint collect: [:each | each parent]) asSet.
]

{ #category : #accessing }
QuerySoftDeleteCommand >> useBinding [
	"For simplicity, just don't use binding here to start with"
	^false.
]
