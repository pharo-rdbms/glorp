"
This is the normal class to use for select queries. It generates SQL for a select operation returning a set of rows.

Instance Variables:
	boundExpressions	<(Collection of: GlorpExpression)>	The expressions for which we need bind parameters. We expect that these are things that resolve to fields, or more generally, to something the database will accept as a valid thing to bind ofr.
	query	<Query>	The query in which we're executing.


"
Class {
	#name : #QuerySelectCommand,
	#superclass : #SelectCommand,
	#instVars : [
		'boundExpressions'
	],
	#category : #'Glorp-Database'
}

{ #category : #accessing }
QuerySelectCommand >> bindingTypes [

	self useBinding ifFalse: [ ^ #(  ) ].
	boundExpressions ifNil: [ self findBoundExpressions ].
	^ boundExpressions collect: [ :each | each bindingType ]
]

{ #category : #accessing }
QuerySelectCommand >> bindings [

	self useBinding ifFalse: [ ^ #(  ) ].
	boundExpressions ifNil: [ self findBoundExpressions ].
	^ boundExpressions collect: [ :each | each bindingIn: self ]
]

{ #category : #accessing }
QuerySelectCommand >> blockFactor [

	blockFactor ifNil: [ blockFactor := query expectedRows ].
	^ blockFactor
]

{ #category : #accessing }
QuerySelectCommand >> boundExpressions [

	^ boundExpressions
]

{ #category : #accessing }
QuerySelectCommand >> boundExpressions: anObject [

	boundExpressions := anObject
]

{ #category : #accessing }
QuerySelectCommand >> findBoundExpressions [

	self useBinding ifFalse: [ ^ nil ].
	boundExpressions := OrderedCollection new.
	query addBoundExpressionsIn: self to: boundExpressions
]

{ #category : #accessing }
QuerySelectCommand >> maximumLobSizeToRetrieveDirectly [

	^ query
		  ifNil: [ super maximumLobSizeToRetrieveDirectly ]
		  ifNotNil: [ query maximumLobSizeToRetrieveDirectly ]
]

{ #category : #printing }
QuerySelectCommand >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	query printOn: aStream.
	aStream nextPut: $)
]

{ #category : #printing }
QuerySelectCommand >> printSQL [

	stream nextPutAll: 'SELECT '.
	query printSelectFieldsOn: self.
	self findBoundExpressions.
	query printTablesOn: self.
	query printWhereClauseOn: self.
	query printJoinsOn: self.
	query printGroupingOn: self.
	query printOrderingOn: self.
	query printPostLimitOn: self.
	query printOffsetOn: self
]

{ #category : #accessing }
QuerySelectCommand >> query [

	^ query
]

{ #category : #accessing }
QuerySelectCommand >> query: aQuery [

	query := aQuery
]

{ #category : #reporting }
QuerySelectCommand >> tables [

	^ (self query tablesToPrint collect: [ :each | each parent ]) asSet
]
