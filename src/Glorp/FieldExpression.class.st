"
This is an expression representing a field in a table. It could be used, for example, if we were writing a data level expression.
   getTable: 'foo') getField: 'bar'

Instance Variables:
	alias	<Object>	Sometimes in queries we want to retrieve values in columns other than what they are normally named. So we can give the field an alias, and generate something like ""select id, name as somethingElse""
	base	<GlorpExpression>	The expression this is based on, which ought to be something which is associated with the table that contains our field.
	field	<DatabaseField>	The field we represent in the expression.


"
Class {
	#name : #FieldExpression,
	#superclass : #GlorpExpression,
	#instVars : [
		'field',
		'base',
		'alias'
	],
	#category : #'Glorp-Expressions'
}

{ #category : #'instance creation' }
FieldExpression class >> forField: aField basedOn: anObjectExpression [

	^(self new) 
		field: aField base: anObjectExpression; 
		yourself
]

{ #category : #accessing }
FieldExpression >> alias [
	^alias
]

{ #category : #accessing }
FieldExpression >> alias: aString [
	"What column name, if anything, should we print for 'as X' when retrieving"
	alias := aString
]

{ #category : #preparing }
FieldExpression >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get 
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."
	| newTarget |
	newTarget := (target allControlledTables includes: field table) 
		ifTrue: [target]
		ifFalse: [base asExpressionJoiningSource: source toTarget: target].
	^newTarget getField: field.
]

{ #category : #accessing }
FieldExpression >> base [

	^base.
]

{ #category : #accessing }
FieldExpression >> basicField [
	^field.
]

{ #category : #testing }
FieldExpression >> canBeUsedForRetrieve [
	"Return true if this is a valid argument for a retrieve: clause"
	^true.
]

{ #category : #accessing }
FieldExpression >> canHaveBase [
	"Return true if this type of expression can have a base expression on which other things can be built. Doesn't say whether we actually have a valid one or not."
	^true.
]

{ #category : #'As yet unclassified' }
FieldExpression >> convertedDbValueOf: anObject [
	"We don't do any conversion"
	^anObject
]

{ #category : #converting }
FieldExpression >> converterForStType: aClass [
	^self field converterForStType: aClass.
]

{ #category : #iterating }
FieldExpression >> do: aBlock skipping: aSet [
	"Iterate over the expression tree"

	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	base do: aBlock skipping: aSet.
	aBlock value: self.
]

{ #category : #accessing }
FieldExpression >> field [
	^base translateField: field
]

{ #category : #initializing }
FieldExpression >> field: aField base: anObjectExpression [

	field := aField.
	base := anObjectExpression.
]

{ #category : #accessing }
FieldExpression >> fieldExpression [
	^self.
]

{ #category : #api }
FieldExpression >> get: aSymbol withArguments: anArray [

	| functionExpression |
	functionExpression := self getFunction: aSymbol withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	anArray isEmpty ifTrue: [self error: 'Field expressions do not have attributes'].
	^RelationExpression named: aSymbol basedOn: self withArguments: anArray.
]

{ #category : #testing }
FieldExpression >> hasField [
	^true.
]

{ #category : #accessing }
FieldExpression >> impliedSmalltalkType [
	^self field impliedSmalltalkType.
]

{ #category : #mapping }
FieldExpression >> mappedFields [
	^Array with: self field.
]

{ #category : #mapping }
FieldExpression >> mappedFieldsCount [
	^1.
]

{ #category : #accessing }
FieldExpression >> name [
	^field name.
]

{ #category : #printing }
FieldExpression >> printOnlySelfOn: aStream [ 
	base printsTable
		ifTrue: [field printUnqualifiedSQLOn: aStream withParameters: #()]
		ifFalse: [field printSQLOn: aStream withParameters: #()]
]

{ #category : #'printing SQL' }
FieldExpression >> printSQLOn: aStream withParameters: aDictionary [
	self field printSQLOn: aStream withParameters:aDictionary.
]

{ #category : #'printing SQL' }
FieldExpression >> printSelectSQLOn: aStream withParameters: aDictionary [
	self printSQLOn: aStream withParameters:aDictionary.
	alias notNil ifTrue: [aStream nextPutAll: ' AS '; nextPutAll: alias].
]

{ #category : #printing }
FieldExpression >> printTreeOn: aStream [ 
	base printOn: aStream.
	aStream nextPut: $..
	base printsTable 
		ifTrue: [field printUnqualifiedSQLOn: aStream withParameters: #()]
		ifFalse: [field printSQLOn: aStream withParameters: #()]
]

{ #category : #'printing SQL' }
FieldExpression >> printUnqualifiedSQLOn: aStream withParameters: aDictionary [
	self field printUnqualifiedSQLOn: aStream withParameters:aDictionary.
]

{ #category : #navigating }
FieldExpression >> queryLevelBaseExpression [
	^base queryLevelBaseExpression.
]

{ #category : #'As yet unclassified' }
FieldExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	| result |
	self == anExpression ifTrue: [^aBaseExpression].
	result := (base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression) getField: field.
	result alias: self alias.
	^result.
]

{ #category : #copying }
FieldExpression >> setTable: aTable [
	"Modify (do not copy) ourselves to use aTable. Presumably aTable is an aliased version of our table"
	field := field withTable: aTable.
]

{ #category : #accessing }
FieldExpression >> table [
	^self field table.
]

{ #category : #'As yet unclassified' }
FieldExpression >> tableForANSIJoin [
	^self field table.
]

{ #category : #preparing }
FieldExpression >> tables [

	^base tables.
]

{ #category : #preparing }
FieldExpression >> tablesToPrint [

	^Array with: self table
]

{ #category : #accessing }
FieldExpression >> type [
	^self field type.
]

{ #category : #navigating }
FieldExpression >> ultimateBaseExpression [
	^base ultimateBaseExpression.
]

{ #category : #mapping }
FieldExpression >> valueInBuilder: anElementBuilder [
	^self valueInBuilder: anElementBuilder as: self field.
]

{ #category : #mapping }
FieldExpression >> valueInBuilder: anElementBuilder as: anExpression [
	^anElementBuilder valueOfField: anExpression.
]

{ #category : #copying }
FieldExpression >> withTable: aTable [
	"Modify (do not copy) ourselves to use aTable. Presumably aTable is an aliased version of our table"
	field := field withTable: aTable.
]
