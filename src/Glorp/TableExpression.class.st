"
This is an expression representing a table. Typically we refer to things in terms of objects which control tables, but sometimes you want to refer directly to a table that's not mapped, either in the process of building up a more OO representing (e.g. referring to a link table) or because we just want to do something more complicated that's not mapped, or incompletely mapped.

Instance Variables:
	base	<BaseExpression | MappingExpression>	The expression on which we are built.
	table	<DatabaseTable>	The table that we represent.


"
Class {
	#name : #TableExpression,
	#superclass : #ObjectExpression,
	#instVars : [
		'table',
		'base'
	],
	#category : 'Glorp-Expressions'
}

{ #category : #'instance creation' }
TableExpression class >> forTable: aDatabaseTable basedOn: aBaseExpression [

	^(self new) 
		table: aDatabaseTable base: aBaseExpression; 
		yourself
]

{ #category : #preparing }
TableExpression >> aliasedTableFor: aDatabaseTable [ 
	^self controlsTables 
		ifTrue: [super aliasedTableFor: aDatabaseTable]
		ifFalse: [base aliasedTableFor: aDatabaseTable]
]

{ #category : #preparing }
TableExpression >> aliasedTableFor: aDatabaseTable ifAbsent: aBlock [
	^self controlsTables 
		ifTrue: [super aliasedTableFor: aDatabaseTable ifAbsent: aBlock]
		ifFalse: [base aliasedTableFor: aDatabaseTable ifAbsent: aBlock]
]

{ #category : #preparing }
TableExpression >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get 
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."

	^(source tablesContainingMe includes: table) ifTrue: [source] ifFalse: [target getTable: table].
]

{ #category : #accessing }
TableExpression >> base [

	^base.
]

{ #category : #accessing }
TableExpression >> canHaveBase [
	"Return true if this type of expression can have a base expression on which other things can be built. Doesn't say whether we actually have a valid one or not."
	^true.
]

{ #category : #testing }
TableExpression >> canPrint [
	"Return true if we can print into a where clause"
	^false.
]

{ #category : #preparing }
TableExpression >> controlsTables [
	"We can end up with a table expression built on top of a base that has the same table. If so, we don't count as controlling that table"

	base isNil ifTrue: [^true].
	base hasDescriptor ifFalse: [^true].
	^(base descriptor tables includes: table) not.
]

{ #category : #iterating }
TableExpression >> do: aBlock skipping: aSet [
	"Iterate over the expression tree"

	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	base do: aBlock skipping: aSet.
	aBlock value: self.
]

{ #category : #api }
TableExpression >> getFieldThatsAnActualFieldObject: aField [

	^self mappingExpressions at: aField ifAbsentPut: [self newFieldExpressionFor: aField].
]

{ #category : #api }
TableExpression >> getTable: aTable [
	self error: 'getting a table from a table expression doesn''t make sense'.
]

{ #category : #printing }
TableExpression >> printOnlySelfOn: aStream [

	table printSQLOn: aStream withParameters: #().
	self printTableAliasesOn: aStream.
]

{ #category : #printing }
TableExpression >> printTreeOn: aStream [ 
	base printOn: aStream.
	aStream nextPut: $..
	table printSQLOn: aStream withParameters: #()
]

{ #category : #accessing }
TableExpression >> printsTable [

	^true.
]

{ #category : #accessing }
TableExpression >> queryLevelBaseExpression [
	^base queryLevelBaseExpression.
]

{ #category : #preparing }
TableExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	self == anExpression ifTrue: [^aBaseExpression].
	^(base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression) getTable: table.
]

{ #category : #api }
TableExpression >> referenceClass [
	"Return the class that our mapping refers to, if we have a mapping. If we're a base expression, just return our class, and if we're a table expression, just return nil."
	^nil.
]

{ #category : #accessing }
TableExpression >> table [

	^table.
]

{ #category : #'initialize/release' }
TableExpression >> table: aDatabaseTable base: aBaseExpression [

	table := aDatabaseTable.
	base := aBaseExpression.
]

{ #category : #accessing }
TableExpression >> tables [

	^Array with: table.
]

{ #category : #preparing }
TableExpression >> tablesToPrint [

	self controlsTables ifFalse: [^#()].
	^Array with: (self aliasedTableFor: table).
]

{ #category : #accessing }
TableExpression >> ultimateBaseExpression [
	^base ultimateBaseExpression.
]
