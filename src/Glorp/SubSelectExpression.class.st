"
This is a special sort of relation expression used when printing subselects that are generated out of anySatisfy: or noneSatisfy: using an EXISTS/NOT EXISTS clause.

Instance Variables:
	localBase	<SubSelectBaseExpression>	The base expression that our sub-query is built on, as opposed to the overall base expression of query.
	query	<SimpleQuery>	The sub-query we are responsible for.


"
Class {
	#name : 'SubSelectExpression',
	#superclass : 'RelationExpression',
	#instVars : [
		'query',
		'localBase'
	],
	#category : 'Glorp-Expressions',
	#package : 'Glorp',
	#tag : 'Expressions'
}

{ #category : 'preparing' }
SubSelectExpression >> addBoundExpressionsIn: aCommand to: boundExpressions [
	self query prepare.
	self query addBoundExpressionsIn: aCommand to: boundExpressions.
]

{ #category : 'preparing' }
SubSelectExpression >> condensePrimaryKeyComparison [
	"Relies on this having been called after the children are condensed. If the child has had its reference to our base condensed away, then we aren't necessary, the comparison is at the same level and no longer needs a subselect"
	^leftChild queryLevelBaseExpression == rightChild queryLevelBaseExpression ifTrue: [rightChild] ifFalse: [self].
]

{ #category : 'accessing' }
SubSelectExpression >> descriptor [
	^self leftChild descriptor.
]

{ #category : 'accessing' }
SubSelectExpression >> initializeQuery [
	query := Query
		read: localBase descriptor describedClass
		where: rightChild.
	query tablePrefix: ('s', localBase ultimateBaseExpression availableSubSelectNumber printString, 't').
"	query baseExpression: localBase."
	query session: localBase descriptor session.
	localBase descriptor tables do: [:eachTable |
		eachTable primaryKeyFields do: [:each | query retrieve: [:base | base getField: each]]].
]

{ #category : 'internal' }
SubSelectExpression >> named: aSymbol basedOn: anExpression withArguments: anArray [

	| right |
	outerJoin := false.
	relation := self operationFor: aSymbol.
	leftChild := anExpression base.

	localBase := SubSelectBaseExpression on: anExpression.
	right := anArray first.
	rightChild := right rebuildOn: localBase startingFrom: anExpression.
]

{ #category : 'printing SQL' }
SubSelectExpression >> printSQLOn: aStream withParameters: aDictionary [ 
	| command toPrint |
	toPrint := relation = #noneSatisfy: ifTrue: ['NOT EXISTS ('] ifFalse: [' EXISTS ('].
	aStream nextPutAll: toPrint.
	command := self query sqlWith: aDictionary.
	aStream nextPutAll: command sqlString.
	aStream nextPutAll: ')'.
]

{ #category : 'accessing' }
SubSelectExpression >> query [
	query isNil ifTrue: [self initializeQuery].
	^query.
]

{ #category : 'preparing' }
SubSelectExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	| expression left |
	self == anExpression ifTrue: [^aBaseExpression].
	"We've swallowed our left child, so we have to unswallow it before rebuilding"
	left := localBase trueBase rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression.
	expression := left 
		get: relation
		withArguments:
			(Array
				with:
					(self rightChildToRebuild rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression)).
	self isOuterJoin ifTrue: [expression beOuterJoin].
	^expression.
]
