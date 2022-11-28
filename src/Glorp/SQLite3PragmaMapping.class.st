"
Pragma mapping for SQLite3
"
Class {
	#name : #SQLite3PragmaMapping,
	#superclass : #ToManyMapping,
	#category : 'Glorp-Mappings'
}

{ #category : #mapping }
SQLite3PragmaMapping >> buildQuery [
	| toMany |
	toMany := self attribute isCollectionAttribute.
	query := toMany
		ifTrue: [SQLite3PragmaQuery read: self referenceClass where: self join]
		ifFalse: [SQLite3PragmaQuery readOneOf: self referenceClass where: self join].
	query session: self session.
	query baseExpression descriptor: (self session descriptorFor: self referenceClass).
	query collectionType: self collectionType.
	self usesLinkTable ifTrue: [
		query AND: (self expressionFromLinkToReferenceTableWithBase: query baseExpression)].
	orderBy isNil ifFalse: [orderBy do: [:each | query orderBy: each]].
	^query
]

{ #category : #'initialize-release' }
SQLite3PragmaMapping >> initialize [
	"Initialize a newly created instance. This method must answer the receiver."

	super initialize.
	" *** Replace this comment with the appropriate initialization code *** "
	^self
]

{ #category : #public }
SQLite3PragmaMapping >> setValueIn: anObject to: aValue [
	"This method serves as a hook to do special work for the collection objects, #fields and #foreignKeysData.
	It connects the objects to their owning tables (a SQLite3DatabaseTable object), and also resets the field
	type for a primary key field whose owning table has 'AUTOINCREMENT' declared for its pkey field. Such
	a field has type #serial. It would be nicer if that info were available elsewhere, but right now, this is where
	the table and field first meet (and where that info can now be shared)."

	self canRead ifFalse: [^self].
	self attribute setValueIn: anObject to: aValue.
	self attribute name = #fields
		ifTrue: 
			[aValue do: 
					[:fld |
					fld table: anObject.
					fld isPrimaryKey
						ifTrue: [anObject hasAutoIncrement ifTrue: [fld type: self descriptor system platform serial]]]].
	self attribute name = #foreignKeysData
		ifTrue: [aValue do: [:fld | fld sourceTableName: anObject name]]
]
