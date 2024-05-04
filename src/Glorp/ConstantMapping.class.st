"
Sometimes you just want a constant value to be set, either in the row, the object or both. And sometimes you just want a non-mapping (e.g. with a ConditionalMapping where one
of the conditions means ""this isn't mapped""). This mapping represents these situations.
It also handles the special case where it's useful to have access to the session inside a
domain object, by allowing you to map it to an instance variable.

So far only the case of mapping to an inst var is implemented.

Instance Variables:

"
Class {
	#name : 'ConstantMapping',
	#superclass : 'Mapping',
	#instVars : [
		'constantValue',
		'valueIsSession'
	],
	#category : 'Glorp-Mappings',
	#package : 'Glorp',
	#tag : 'Mappings'
}

{ #category : 'accessing' }
ConstantMapping >> constantValue [
	^constantValue
]

{ #category : 'accessing' }
ConstantMapping >> constantValue: anObject [

	constantValue := anObject
]

{ #category : 'accessing' }
ConstantMapping >> constantValueIn: aSession [

	^valueIsSession
		ifTrue: [aSession]
		ifFalse: [constantValue].
]

{ #category : 'accessing' }
ConstantMapping >> constantValueIsSession [

	valueIsSession := true
]

{ #category : 'testing' }
ConstantMapping >> controlsTables [
	"Return true if this type of method 'owns' the tables it's associated with, and expression nodes using this mapping should alias those tables where necessary"

	^false
]

{ #category : 'api' }
ConstantMapping >> getValueFrom: anObject [

	^constantValue
]

{ #category : 'initialization' }
ConstantMapping >> initialize [

	super initialize.
	valueIsSession := false.
]

{ #category : 'testing' }
ConstantMapping >> isRelationship [
	^false
]

{ #category : 'mapping' }
ConstantMapping >> mapFromObject: anObject intoRowsIn: aRowMap [
]

{ #category : 'mapping' }
ConstantMapping >> mapObject: anObject inElementBuilder: anElementBuilder [
	| value |
	value := anElementBuilder isNil
		ifTrue: [constantValue]
		ifFalse: [self constantValueIn: anElementBuilder session].
	self setValueIn: anObject to: value
]

{ #category : 'accessing' }
ConstantMapping >> mappedFields [
	"Return a collection of fields that this mapping will write into any of the containing object's rows"

	^#()
]

{ #category : 'mapping' }
ConstantMapping >> referencedIndependentObjectsFrom: anObject [

	^#()
]

{ #category : 'mapping' }
ConstantMapping >> trace: aTracing context: anExpression [

	^self
]

{ #category : 'validation' }
ConstantMapping >> validateAttribute [
	^self
]
