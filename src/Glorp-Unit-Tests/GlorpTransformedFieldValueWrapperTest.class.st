Class {
	#name : #GlorpTransformedFieldValueWrapperTest,
	#superclass : #TestCase,
	#instVars : [
		'inner',
		'outer'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #accessing }
GlorpTransformedFieldValueWrapperTest >> inner [
	^inner
]

{ #category : #accessing }
GlorpTransformedFieldValueWrapperTest >> inner: aFieldValueWrapper [
	inner := aFieldValueWrapper
]

{ #category : #accessing }
GlorpTransformedFieldValueWrapperTest >> outer [
	^outer
]

{ #category : #accessing }
GlorpTransformedFieldValueWrapperTest >> outer: aTransformingFieldValueWrapper [
	outer := aTransformingFieldValueWrapper
]

{ #category : #support }
GlorpTransformedFieldValueWrapperTest >> setUp [
	super setUp.
	inner := FieldValueWrapper new.
	outer := TransformingFieldValueWrapper new innerWrapper: inner; forwardTransformation: [:a | a * 2]; inverseTransformation: [:a | a / 2].
]

{ #category : #tests }
GlorpTransformedFieldValueWrapperTest >> testPrivateSetOuter [

	self deny: inner hasValue.
	self deny: outer hasValue.
	outer privateSetContents: 8.
	self assert: outer contents equals: 8.
	self assert: inner contents equals: 4.
	self assert: inner hasValue.
	self assert: outer hasValue
]

{ #category : #tests }
GlorpTransformedFieldValueWrapperTest >> testSetInner [

	self deny: inner hasValue.
	self deny: outer hasValue.
	inner contents: 3.
	self assert: outer contents equals: 6.
	self assert: inner contents equals: 3.
	self assert: inner hasValue.
	self assert: outer hasValue
]

{ #category : #tests }
GlorpTransformedFieldValueWrapperTest >> testSetOuter [

	self deny: inner hasValue.
	self deny: outer hasValue.
	outer contents: 8.
	self assert: outer contents equals: 8.
	self assert: inner contents equals: 4.
	self assert: inner hasValue.
	self assert: outer hasValue
]

{ #category : #tests }
GlorpTransformedFieldValueWrapperTest >> testSetOuterFails [

	self deny: inner hasValue.
	self deny: outer hasValue.
	outer contents: 8.
	self should: [outer contents: 9] raise: Dialect error.
	self assert: outer contents equals: 8.
	self assert: inner contents equals: 4.
	self assert: inner hasValue.
	self assert: outer hasValue
]
