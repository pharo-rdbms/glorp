"
This represent a query that does a bulk update with a where clause

Instance Variables
	query	<SimpleQuery>	The query that holds our where clause.
"
Class {
	#name : 'QuerySoftDeleteCommand',
	#superclass : 'QueryDeleteCommand',
	#category : 'Glorp-Database',
	#package : 'Glorp',
	#tag : 'Database'
}

{ #category : 'printing' }
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
	query printUnqualifiedWhereClauseOn: self
]
