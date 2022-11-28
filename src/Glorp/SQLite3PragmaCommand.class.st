"
Pragma command for SQL3
"
Class {
	#name : #SQLite3PragmaCommand,
	#superclass : #SQLStringSelectCommand,
	#category : 'Glorp-Core'
}

{ #category : #sql }
SQLite3PragmaCommand >> printSQL [

	stream nextPutAll: 'PRAGMA '.
	query resultClass name = #DatabaseField 
		ifTrue: [stream nextPutAll: 'table_info ('].
	query resultClass name = #SQLite3ForeignKeyData
		ifTrue: [stream nextPutAll: 'foreign_key_list('].
	query resultClass name = #SQLite3IndexData
		ifTrue: [stream nextPutAll: 'index_list('].
	query resultClass name = #SQLite3IndexColumnData
		ifTrue: [stream nextPutAll: 'index_info('].
	"query printSelectFieldsOn: self."
	self findBoundExpressions.
	"query printTablesOn: self."
	query printWhereClauseOn: self.
	stream nextPutAll: ')'
	"query printJoinsOn: self.
	query printOrderingOn: self.
	query printGroupByOn: self.
	query printPostLimitOn: self.
	query printOffsetOn: self."
]
