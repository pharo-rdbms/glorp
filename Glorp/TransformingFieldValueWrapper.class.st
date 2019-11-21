"
This wraps another wrapper and transforms its value.

Instance Variables:
	forwardTransformation	<Block>	What to do to convert our value going out.
	innerWrapper	<FieldValueWrapper>	The wrapper that really has the value.
	inverseTransformation	<Block>	What to do to convert our value going in.


"
Class {
	#name : #TransformingFieldValueWrapper,
	#superclass : #FieldValueWrapper,
	#instVars : [
		'forwardTransformation',
		'inverseTransformation',
		'innerWrapper'
	],
	#category : 'Glorp-UnitOfWork'
}

{ #category : #accessing }
TransformingFieldValueWrapper >> allInnerWrappers [
	^innerWrapper allInnerWrappers, (Array with: innerWrapper)
]

{ #category : #accessing }
TransformingFieldValueWrapper >> basicContents [
	"Return the un-transformed contents"
	^innerWrapper contents
]

{ #category : #unifying }
TransformingFieldValueWrapper >> containsWrapper: aFieldValueWrapper [
	^self == aFieldValueWrapper or: [innerWrapper == aFieldValueWrapper
		or: [aFieldValueWrapper innerWrapper == self
			or: [aFieldValueWrapper innerWrapper == self innerWrapper]]]
]

{ #category : #accessing }
TransformingFieldValueWrapper >> contents [

	^forwardTransformation value: innerWrapper contents
]

{ #category : #accessing }
TransformingFieldValueWrapper >> contents: anObject [

	innerWrapper contents: (inverseTransformation value: anObject)
]

{ #category : #accessing }
TransformingFieldValueWrapper >> forwardTransformation [
	^forwardTransformation
]

{ #category : #accessing }
TransformingFieldValueWrapper >> forwardTransformation: aBlock [
	forwardTransformation := aBlock
]

{ #category : #accessing }
TransformingFieldValueWrapper >> hasValue [

	^innerWrapper hasValue
]

{ #category : #accessing }
TransformingFieldValueWrapper >> innerWrapper [
	^innerWrapper
]

{ #category : #accessing }
TransformingFieldValueWrapper >> innerWrapper: aFieldValueWrapper [
	innerWrapper := aFieldValueWrapper
]

{ #category : #accessing }
TransformingFieldValueWrapper >> inverseTransformation [
	^inverseTransformation
]

{ #category : #accessing }
TransformingFieldValueWrapper >> inverseTransformation: aBlock [
	inverseTransformation := aBlock
]

{ #category : #accessing }
TransformingFieldValueWrapper >> privateSetContents: anObject [
	innerWrapper privateSetContents: (inverseTransformation value: anObject)
]

{ #category : #unifying }
TransformingFieldValueWrapper >> replaceWith: aFieldValueWrapper [
	innerWrapper replaceWith: aFieldValueWrapper
]
