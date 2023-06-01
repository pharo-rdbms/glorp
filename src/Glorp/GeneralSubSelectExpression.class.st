"
This represents an arbitrary sub-select. This would normally get created by embedding a query instance inside a query block. For example
   where: [:each | each id > 2 & (each something = aWholeOtherQuery)].
Warning: This can be get very complicated, especially if aWholeOtherQuery refers to variables inside the main query block, creating a correlated subselect.

Instance Variables:
	query	<Query>	The query that we subselect.


"
Class {
	#name : #GeneralSubSelectExpression,
	#superclass : #GlorpExpression,
	#instVars : [
		'query',
		'base'
	],
	#category : #'Glorp-Expressions'
}

{ #category : #'instance creation' }
GeneralSubSelectExpression class >> basedOn: anExpression [
	"The defining characteristic of a general subselect is that it doesn't care what it's based on. The base is just a convenient place to hang an independent expression. So make sure we're built on a true base, which won't print confusing stuff for us"
	^self new base: anExpression ultimateBaseExpression
]

{ #category : #preparing }
GeneralSubSelectExpression >> addBoundExpressionsIn: aCommand to: boundExpressions [

	self query session: aCommand query session.
	self query prepare.
	self query addBoundExpressionsIn: aCommand to: boundExpressions
]

{ #category : #preparing }
GeneralSubSelectExpression >> asExpressionJoiningSource: source toTarget: target [
	" *** This method was defined by Glorp.GlorpExpression as a subclass responsibility.
	Replace its body with a proper implementation. *** "

	self error: 'Subclass responsibility stub not reimplemented'
]

{ #category : #converting }
GeneralSubSelectExpression >> asJoin [
	" *** This method was defined by Glorp.GlorpExpression as a subclass responsibility.
	Replace its body with a proper implementation. *** "

	self error: 'Subclass responsibility stub not reimplemented'
]

{ #category : #api }
GeneralSubSelectExpression >> base [

	^ base
]

{ #category : #accessing }
GeneralSubSelectExpression >> base: anExpression [

	base := anExpression
]

{ #category : #testing }
GeneralSubSelectExpression >> canHaveBase [
	"Return true if this type of expression can have a base expression on which other things can be built. Doesn't say whether we actually have a valid one or not."

	^ true
]

{ #category : #converting }
GeneralSubSelectExpression >> convertedDbValueOf: anObject [

	^ anObject
]

{ #category : #accessing }
GeneralSubSelectExpression >> descriptor [

	^ base system descriptorFor: query resultClass
]

{ #category : #accessing }
GeneralSubSelectExpression >> field [

	^ nil
]

{ #category : #api }
GeneralSubSelectExpression >> get: aSymbol withArguments: anArray [

	| functionExpression |
	functionExpression := self getFunction: aSymbol withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	^ RelationExpression
		named: aSymbol
		basedOn: self
		withArguments: anArray
]

{ #category : #api }
GeneralSubSelectExpression >> getField: aField [
	"This is rather a hack on the use of get:, but I think it should be all right because we should never run into one of these in normal expression generation. The issue is that if we do an expression of the form (x = aQuery) where the query returns an object of the same class as X. We want to rewrite that into a primary key comparison for the database, so we want to do a get: against aQuery. But the only thing that seems to sensibly translate into is a retrieve: clause and return the query. That will only work for a single level get:, but I think that a multi-level one, from converting a block, shouldn't ever get to a general sub-select."

	query retrieve: [ :each | each getField: aField ]
]

{ #category : #api }
GeneralSubSelectExpression >> getMapping: aMapping named: aSymbol [
	"Suppose we do an expression of the form (x = aQuery) where the query returns an object of the same class as X. We want to rewrite that into a primary key comparison for the database, so we want to do a getMapping:named: against aQuery. But the only thing that seems to sensibly translate into is a retrieve: clause and return the query. That will only work for a single level get:, but I think that a multi-level one, from converting a block, shouldn't ever get to a general sub-select."

	query retrieve: aSymbol
]

{ #category : #testing }
GeneralSubSelectExpression >> isMappable [
	"Return true if we're something that can be returned in a select statement."

	^ false
]

{ #category : #accessing }
GeneralSubSelectExpression >> mappedFields [
	"Let's try this and see if it works returning empty"

	^ #(  )
]

{ #category : #printing }
GeneralSubSelectExpression >> printOnlySelfOn: aStream [
	" *** This method was defined by Glorp.GlorpExpression as a subclass responsibility.
	Replace its body with a proper implementation. *** "

	self error: 'Subclass responsibility stub not reimplemented'
]

{ #category : #printing }
GeneralSubSelectExpression >> printSQLOn: aStream withParameters: aDictionary [

	| command |
	aStream nextPutAll: '('.
	self query session: aStream query session.
	command := self query sqlWith: aDictionary.
	aStream nextPutAll: command sqlString.
	aStream nextPutAll: ')'
]

{ #category : #printing }
GeneralSubSelectExpression >> printSelectSQLOn: aStream withParameters: aDictionary [

	self printSQLOn: aStream withParameters: aDictionary
]

{ #category : #printing }
GeneralSubSelectExpression >> printTreeOn: aStream [

	aStream nextPutAll: 'subselect('.
	query printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
GeneralSubSelectExpression >> query [

	^ query
]

{ #category : #accessing }
GeneralSubSelectExpression >> query: aQuery [

	query := aQuery
]

{ #category : #preparing }
GeneralSubSelectExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [

	| rebuiltBase rebuilt |
	self == anExpression ifTrue: [^aBaseExpression].
	rebuiltBase := base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression.
	rebuilt := self copy.
	rebuilt base: rebuiltBase.
	rebuilt query: (query rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression).
	^rebuilt.
"	^query asGlorpExpressionOn: aBaseExpression."
]

{ #category : #accessing }
GeneralSubSelectExpression >> type [

	^ query resultType
]

{ #category : #navigating }
GeneralSubSelectExpression >> ultimateBaseExpression [

	^ base ultimateBaseExpression
]
