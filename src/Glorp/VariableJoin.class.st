"
This represents a join that could be to multiple different tables, e.g. when using horizontal inheritance.

Instance Variables:
	joins	<Dictionary from: Class to: Join>	description of joins


"
Class {
	#name : 'VariableJoin',
	#superclass : 'Object',
	#instVars : [
		'joins'
	],
	#category : 'Glorp-Expressions',
	#package : 'Glorp',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
VariableJoin class >> new [
	^(super new )initialize
]

{ #category : 'accessing' }
VariableJoin >> addJoinFor: aClass as: aJoin [
	joins at: aClass put: aJoin
]

{ #category : 'accessing' }
VariableJoin >> allSourceFields [
	"We assume that variable joins vary in the targets, not the in sources."
	^self anyJoin allSourceFields
]

{ #category : 'accessing' }
VariableJoin >> allTargetFields [
	^joins inject: OrderedCollection new into: [:sum :each | sum addAll: each allTargetFields. sum]
]

{ #category : 'accessing' }
VariableJoin >> anyJoin [
	^joins detect: [:each | true]
]

{ #category : 'converting' }
VariableJoin >> asGeneralGlorpExpression [
	"We know that we represent querying for an abstract class, so we don't want to convert ourselves to a join form, but rather just to a source mapping form. There are some assumptions in here, but it should work for the basic cases anyway."

	| base expression anyJoin descriptor |
	anyJoin := self anyJoin.
	base := anyJoin base.
	descriptor := base system findDescriptorForTable: anyJoin allTargetFields first table.
	expression := EmptyExpression new base: base.
	anyJoin mappableFieldsDo: [:source :target |
		| mapping thingToCompare |
		mapping := descriptor mappingForField: target.
		thingToCompare := mapping isNil
			ifTrue: [base getField: target]
			ifFalse: [base get: mapping attributeName].
		expression := expression AND: (thingToCompare get: #= withArguments: (Array with: (source asGlorpExpressionOn: base)))].
	^expression.
]

{ #category : 'converting' }
VariableJoin >> asGeneralGlorpExpressionWithFields [
	"The normal conversion of a join is to an expression equating fields and parameters. Instead, generate one with field to field comparisons."

	| base expression mappingName anyJoin descriptor |
	anyJoin := self anyJoin.
	base := anyJoin base.
	descriptor := base system findDescriptorForTable: anyJoin allTargetFields first table.
	expression := EmptyExpression new base: base.
	anyJoin mappableFieldsDo: [:source :target |
		mappingName := (descriptor mappingForField: target) attributeName.
		expression := expression AND: ((base get: mappingName) get: #= withArguments: (Array with: (self targetExpressionFor: source)))].
	^expression.
]

{ #category : 'converting' }
VariableJoin >> asGlorpExpressionOn: aBaseExpression [
	| copy |
	copy := self copy.
	copy joins: (copy joins collect: [:each | each asGlorpExpressionOn: aBaseExpression]).
	^copy
]

{ #category : 'accessing' }
VariableJoin >> generalExpressionPart [
	^nil
]

{ #category : 'initialize-release' }
VariableJoin >> initialize [
	joins := IdentityDictionary new
]

{ #category : 'converting' }
VariableJoin >> isConstant: aTarget [
	"The target can be either a constant (which gets turned into a ConstantExpression) or (usually) a DatabaseField, representing a parameter to the query"
	(aTarget class == DatabaseField) ifTrue: [^false].
	(aTarget isGlorpExpression and: [aTarget isConstantExpression not]) ifTrue: [^false].
	^true
]

{ #category : 'testing' }
VariableJoin >> isGlorpExpression [
	^true.
]

{ #category : 'testing' }
VariableJoin >> isJoin [
	^true.
]

{ #category : 'accessing' }
VariableJoin >> joins [
	^joins.
]

{ #category : 'accessing' }
VariableJoin >> joins: aCollection [
	joins := aCollection.
]

{ #category : 'api' }
VariableJoin >> mapFromSource: sourceObject andTarget: targetObject intoRowsIn: aRowMap [
	(sourceObject isNil or: [targetObject isNil]) ifTrue: [^self].
	^(joins at: targetObject class)
		mapFromSource: sourceObject
		andTarget: targetObject
		intoRowsIn: aRowMap.
]

{ #category : 'accessing' }
VariableJoin >> mappableSourceFieldsDo: aBlock [

	self anyJoin mappableSourceFieldsDo: aBlock.
]

{ #category : 'preparing' }
VariableJoin >> prepareIn: aQuery [
]

{ #category : 'As yet unclassified' }
VariableJoin >> primaryKeyFromDictionary: anIdentityDictionary [ 
	^self anyJoin primaryKeyFromDictionary: anIdentityDictionary.
]

{ #category : 'printing' }
VariableJoin >> printOn: aStream [
	[aStream query] on: Error do: [:ex | ^super printOn: aStream].
	(joins at: aStream query resultClass) printOn: aStream.
]

{ #category : 'printing' }
VariableJoin >> printSQLOn: aStream withParameters: aDictionary [ 
	[aStream query] on: Error do: [:ex | ^super printOn: aStream].
	(joins at: aStream query resultClass) printSQLOn: aStream withParameters: aDictionary.
]

{ #category : 'accessing' }
VariableJoin >> queryLevelBaseExpression [
	^self ultimateBaseExpression.
]

{ #category : 'preparing' }
VariableJoin >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	^(self joins at: aBaseExpression descriptor describedClass) 
		rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
]

{ #category : 'As yet unclassified' }
VariableJoin >> shortCircuitOnNullComparison: anIdentityDictionary [ 
	joins do: [:each |
		(each shortCircuitOnNullComparison: anIdentityDictionary)
			ifFalse: [^false]].
	^true.
]

{ #category : 'converting' }
VariableJoin >> targetExpressionFor: eachTarget [ 
	^(self isConstant: eachTarget)
		ifTrue: [eachTarget]
		ifFalse: [
			eachTarget isGlorpExpression 
			ifTrue: [eachTarget] 
			ifFalse: [(self anyJoin base getTable: eachTarget table) getField: eachTarget]].
]

{ #category : 'accessing' }
VariableJoin >> ultimateBaseExpression [

	^self anyJoin base.
]
