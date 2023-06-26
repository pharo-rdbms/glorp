"
When we are creating our rowmap, we need to be able to unify values. That is, we express the constraint that field A in table T1 must be equal to field B in table T2. And we have to be able to do this whether or not we have yet assigned a value to either of these fields, and whether or not other equality constraints have already been imposed on one or the other of these fields. We do this by holding the values in a wrapper. When we unify them, we replace one wrapper with the other, so that both rows now refer to the same value. In order to efficiently find where things are contained, we hold a collection of the containing rows.

Instance Variables:
	containedBy	<(Association key: DatabaseField value: (IdentitySet of: DatabaseRow)) | (IdentityDictionary of: Same)>	The rows that contain this wrapper. Using a trick similar to #dependents, we optimize the containedByCollection to be an association if we are only contained in one row (the most common case). Otherwise we have a dictionary. The containing rows are indexed by field, because when we're updating the row to replace the wrapper, we need to know which field to replace. Also, a single row could conceivably contain the same wrapper in two different fields, and both need to be updated.
	contents	<Object>	The value we contain
	hasValue	<Boolean>	Has our value been set or not. We can't just test for nil in contents, because nil is a valid value.


"
Class {
	#name : #FieldValueWrapper,
	#superclass : #Object,
	#instVars : [
		'contents',
		'hasValue',
		'containedBy'
	],
	#category : #'Glorp-UnitOfWork'
}

{ #category : #accessing }
FieldValueWrapper >> allInnerWrappers [
	^#()
]

{ #category : #accessing }
FieldValueWrapper >> basicContents [
	"Return the un-transformed contents"
	^self contents
]

{ #category : #public }
FieldValueWrapper >> containedBy [

	^containedBy
]

{ #category : #unifying }
FieldValueWrapper >> containsWrapper: aFieldValueWrapper [
	^self == aFieldValueWrapper
]

{ #category : #public }
FieldValueWrapper >> contents [

	^contents
]

{ #category : #public }
FieldValueWrapper >> contents: anObject [

	(hasValue and: [contents ~= anObject]) ifTrue: [self error: 'Inconsistent values in field'].
	self privateSetContents: anObject
]

{ #category : #public }
FieldValueWrapper >> hasValue [

	^hasValue
]

{ #category : #public }
FieldValueWrapper >> initialize [

	hasValue := false
]

{ #category : #accessing }
FieldValueWrapper >> innerWrapper [
	^self
]

{ #category : #containing }
FieldValueWrapper >> isNowContainedBy: aRow and: aField [
	"Optimize this for memory consumption with the common case of one container. If we're contained by nothing, make it a single association. Otherwise, use a dictionary"
	| shortCircuit thisFieldsEntries |
	shortCircuit := false.
	containedBy == nil ifTrue: [containedBy := aField -> ((IdentitySet new: 2) add: aRow; yourself). ^self].
	containedBy class == Association 
		ifTrue: [
		containedBy key == aField
			ifTrue: [thisFieldsEntries := containedBy value]
			ifFalse: [ | newContainedBy |
				newContainedBy := IdentityDictionary new. 
				newContainedBy at: containedBy key put: containedBy value.
				containedBy := newContainedBy]].
	thisFieldsEntries isNil ifTrue: [
		thisFieldsEntries := containedBy at: aField ifAbsentPut: [shortCircuit := true. (IdentitySet new: 2) add: aRow; yourself]].
	shortCircuit ifTrue: [^self].
	(thisFieldsEntries includes: aRow) ifFalse: [thisFieldsEntries add: aRow]
]

{ #category : #public }
FieldValueWrapper >> printOn: aStream [

	aStream 
		nextPutAll: '<<'.
	self hasValue ifTrue: [aStream print: self contents].
	aStream
		nextPutAll: '>>'
]

{ #category : #public }
FieldValueWrapper >> privateSetContents: anObject [
	contents := anObject.
	hasValue := true
]

{ #category : #unifying }
FieldValueWrapper >> replaceWith: aFieldValueWrapper [
	containedBy isNil ifTrue: [^nil].
	containedBy
		keysAndValuesDo:
			[:eachField :eachListOfRows | eachListOfRows do: [:eachRow | eachRow wrapperAt: eachField put: aFieldValueWrapper]]
]

{ #category : #unifying }
FieldValueWrapper >> unifyWith: targetWrapper [
	(self containsWrapper: targetWrapper) ifTrue: [^self].
	(targetWrapper containsWrapper: self) ifTrue: [^self].
	targetWrapper hasValue ifFalse: [^targetWrapper replaceWith: self].
	self hasValue ifFalse: [^self replaceWith: targetWrapper].
	self contents = targetWrapper contents
		ifFalse: [self error: 'Conflicting values in rows'].
	targetWrapper replaceWith: self
]
