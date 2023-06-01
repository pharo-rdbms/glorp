"
This is a special variation of a base expression which is used when we know we are a subselect. In some circumstances we'll need to operate with respect to the subselect base, as if we were a standalone query. But sometimes we'll need to know the broader context in which we're living. Having a separate subclass helps us distinguish.

Instance Variables:
	trueBase	<MappingExpression>	The base on which we are built. Note that this doesn't mean this is the overall base expression, in fact it's probably a mapping expression, it's just the thing from which this subselect was built. Presumably the ultimate base expression can be found by following that outer context down, but there could be multiple levels of subselects involved.


"
Class {
	#name : #SubSelectBaseExpression,
	#superclass : #BaseExpression,
	#instVars : [
		'trueBase'
	],
	#category : #'Glorp-Expressions'
}

{ #category : #'instance creation' }
SubSelectBaseExpression class >> on: aBaseExpression [
	^self new trueBase: aBaseExpression
]

{ #category : #accessing }
SubSelectBaseExpression >> additionalExpressions [
	"We effectively take over the join for the thing we're based on, because we want it to happen in the subselect, not in the main one."

	^ trueBase additionalExpressionsOn: self
]

{ #category : #preparing }
SubSelectBaseExpression >> additionalExpressionsOn: anExpression [

	^ trueBase additionalExpressionsOn: anExpression
]

{ #category : #api }
SubSelectBaseExpression >> base [

	^ trueBase base
]

{ #category : #introspection }
SubSelectBaseExpression >> className [

	^ 'SubSelectBase'
]

{ #category : #converting }
SubSelectBaseExpression >> convertedDbValueOf: anObject [

	^ self trueBase mapping convertedDbValueOf: anObject
]

{ #category : #accessing }
SubSelectBaseExpression >> descriptor [
	^trueBase descriptor.
]

{ #category : #accessing }
SubSelectBaseExpression >> field [

	^ self trueBase mapping field
]

{ #category : #accessing }
SubSelectBaseExpression >> join [

	^ self trueBase join
]

{ #category : #printing }
SubSelectBaseExpression >> printSQLOn: aStream withParameters: aDictionary [
	"If I'm ever going to print this directly, it's because I'm participating in a direct to-many relationship, so I do have a valid field"

	(self translateField: self field)
		printSQLOn: aStream
		withParameters: aDictionary
]

{ #category : #navigating }
SubSelectBaseExpression >> queryLevelBaseExpression [

	^ self
]

{ #category : #preparing }
SubSelectBaseExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	| newBase |
	anExpression isNil ifTrue: [^aBaseExpression].
	anExpression == self ifTrue: [^aBaseExpression].
	newBase := trueBase rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression.
	"If newBase == self, we've already reached this node on another branch and handled it - nothing more to do."
	newBase == self ifFalse: [self trueBase: newBase].
	^self
]

{ #category : #testing }
SubSelectBaseExpression >> representsDerivedObject [
	^self trueBase representsDerivedObject
]

{ #category : #accessing }
SubSelectBaseExpression >> table [

	^ self trueBase table
]

{ #category : #accessing }
SubSelectBaseExpression >> trueBase [

	^ trueBase
]

{ #category : #accessing }
SubSelectBaseExpression >> trueBase: aBaseExpression [

	trueBase := aBaseExpression
]

{ #category : #navigating }
SubSelectBaseExpression >> ultimateBaseExpression [

	^trueBase ultimateBaseExpression
]

{ #category : #preparing }
SubSelectBaseExpression >> validate [

	super validate.
	trueBase validate
]
