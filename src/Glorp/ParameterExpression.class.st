"
This is an expression representing a placeholder for a parameter value. So, e.g. object attribute = <parameter for field OWNER_ID>. This is most frequently used for the queries in proxies, although it can be used anywhere. The parameter can be identified by either a field, a name, or an index, which can get fairly ugly.

Instance Variables:
	base	<GlorpExpression>	Our base expression.
	lookupKey	<DatabaseField | SomethingElse>	The thing based on which we look up our parameter value in the array or dictionary of parameters that's passed to the query. So it can be number (for positional usage), a field, or something else.

. 
"
Class {
	#name : #ParameterExpression,
	#superclass : #GlorpExpression,
	#instVars : [
		'base',
		'lookupKey'
	],
	#category : #'Glorp-Expressions'
}

{ #category : #'instance creation' }
ParameterExpression class >> forField: aField basedOn: anObjectExpression [

	^(self new) 
		field: aField base: anObjectExpression; 
		yourself
]

{ #category : #preparing }
ParameterExpression >> addToTargetFields: aCollection [
	"If we can provide target fields, add them to the collection"
	lookupKey class == DatabaseField ifTrue: [
		aCollection add: lookupKey].
]

{ #category : #preparing }
ParameterExpression >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."

	^ source getField: lookupKey
]

{ #category : #accessing }
ParameterExpression >> base [

	^ base
]

{ #category : #testing }
ParameterExpression >> canBind [
	"Return true if this represents a value that can be bound into a prepared statement"

	^ true
]

{ #category : #testing }
ParameterExpression >> canHaveBase [
	"Return true if this type of expression can have a base expression on which other things can be built. Doesn't say whether we actually have a valid one or not."

	^ true
]

{ #category : #printing }
ParameterExpression >> convertedDbValueOf: anObject [
	"We don't do any conversion"

	^ anObject
]

{ #category : #iterating }
ParameterExpression >> do: aBlock skipping: aSet [

	(aSet includes: self) ifTrue: [ ^ self ].
	aSet add: self.
	base do: aBlock skipping: aSet.
	aBlock value: self
]

{ #category : #accessing }
ParameterExpression >> field [

	^ lookupKey
]

{ #category : #'initialize/release' }
ParameterExpression >> field: aDatabaseField base: aBaseExpression [

	lookupKey := aDatabaseField.
	base := aBaseExpression
]

{ #category : #api }
ParameterExpression >> get: aSelector withArguments: anArray [

	| functionExpression |
	functionExpression := self
		                      getFunction: aSelector
		                      withArguments: anArray.
	functionExpression isNil ifFalse: [ ^ functionExpression ].
	^ RelationExpression
		  named: aSelector
		  basedOn: self
		  withArguments: anArray
]

{ #category : #api }
ParameterExpression >> getMapping: aMapping named: aSymbol [
	"Get an expression given the actual mapping. Only if you really know what you're doing! In this case, what we're probably doing is rewriting a parameter that's a mapped object into a set of parameters, one for each of its primary keys."

	| expression |
	expression := nil.
	aMapping mappedFields do: [ :each |
		expression := (each asGlorpExpressionOn: self) AND: expression ].
	^ expression
]

{ #category : #printing }
ParameterExpression >> printOn: aStream [

	aStream nextPutAll: 'Parameter('.
	self printTreeOn: aStream.
	aStream nextPut: $)
]

{ #category : #printing }
ParameterExpression >> printOnlySelfOn: aStream [

	lookupKey printSQLOn: aStream withParameters: #(  )
]

{ #category : #printing }
ParameterExpression >> printSQLOn: aStream withParameters: aDictionary [

	self field type print: (self valueIn: aDictionary) on: aStream
]

{ #category : #printing }
ParameterExpression >> printTreeOn: aStream [

	[ lookupKey printSQLOn: aStream withParameters: #(  ) ]
		on: Dialect error
		do: [ :ex | lookupKey printOn: aStream ]
]

{ #category : #navigating }
ParameterExpression >> queryLevelBaseExpression [

	^ base queryLevelBaseExpression
]

{ #category : #preparing }
ParameterExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [

	self == anExpression ifTrue: [ ^ aBaseExpression ].
	self base == ultimateBaseExpression ifTrue: [ ^ self ].
	^ aBaseExpression getParameter: lookupKey
]

{ #category : #navigating }
ParameterExpression >> ultimateBaseExpression [

	^ base ultimateBaseExpression
]

{ #category : #accessing }
ParameterExpression >> valueIn: aDictionary [

	^ aDictionary at: lookupKey
]
