"
This holds the metadata describing a class. Since Smalltalk classes are fairly self-describing, this mostly consists of the names and types of the instance variables that we want to be persistent. If those variables are collections, we also want to know the types of the items in the collections.

Instance Variables:
	attributes	<(Collection of: GlorpAttributeModel)>	Our attributes, one for each instance variable.
	describedClass	<Class>	The class we hold metadata for.
	subclasses	<Array of: Class>	The collection of subclasses of our describedClass. Computed automatically, and used as a performance optimization for inheritance testing.
	system	<DescriptorSystem>	The system that contains us.


"
Class {
	#name : #GlorpClassModel,
	#superclass : #Object,
	#instVars : [
		'system',
		'describedClass',
		'subclasses',
		'attributes'
	],
	#category : #'Glorp-Mappings'
}

{ #category : #'instance creation' }
GlorpClassModel class >> for: aClass [
	^self new describedClass: aClass.
]

{ #category : #accessing }
GlorpClassModel >> addAttribute: anAttributeDescription [
	attributes add: anAttributeDescription.
	anAttributeDescription classModel: self.
	^anAttributeDescription
]

{ #category : #accessing }
GlorpClassModel >> attributeNamed: aSymbol [
	^attributes detect: [:each | each name = aSymbol] ifNone: [self newAttributeNamed: aSymbol]
]

{ #category : #accessing }
GlorpClassModel >> attributeNamed: aSymbol type: aClass [
	^attributes
		detect:
			[:each | each name = aSymbol and: [each type isNil or: [each type = aClass]]]
		ifNone: [self newAttributeNamed: aSymbol type: aClass]
]

{ #category : #accessing }
GlorpClassModel >> attributeNamed: aSymbol type: aClass collectionType: collectionClass [
	^attributes
		detect:
			[:each | 
			| collectionTypeMatches typeMatches nameMatches |
			nameMatches := each name = aSymbol.
			typeMatches := each type isNil or: [each type = aClass].
			collectionTypeMatches := each collectionType isNil
				or: [each collectionType = collectionClass].
			nameMatches & typeMatches & collectionTypeMatches]
		ifNone: [self newAttributeNamed: aSymbol type: aClass]
]

{ #category : #accessing }
GlorpClassModel >> attributes [
	^attributes
]

{ #category : #attributes }
GlorpClassModel >> attributesDo: aBlock [
	attributes do: aBlock
]

{ #category : #accessing }
GlorpClassModel >> describedClass [
	^describedClass
]

{ #category : #accessing }
GlorpClassModel >> describedClass: aClass [
	describedClass := aClass.
	subclasses := aClass allSubclasses isEmpty ifTrue: [nil] ifFalse: [aClass allSubclasses asArray]
]

{ #category : #accessing }
GlorpClassModel >> hasAttributeNamed: aSymbol [

	attributes do: [:attribute | attribute name = aSymbol ifTrue: [^true]].
	^false
]

{ #category : #initialization }
GlorpClassModel >> initialize [
	attributes := OrderedCollection new
]

{ #category : #validation }
GlorpClassModel >> matches: anObject [
	"Try to optimize this check as much as possible. We cache the list of subclasses, and inline the check for isKindOf:"
	| theClass |
	theClass := anObject glorpRealObject class.
	describedClass == theClass ifTrue: [^true].
	nil == subclasses ifTrue: [^false].
	1 to: subclasses size do: [:i | theClass == (subclasses at: i)
		ifTrue: [^true]].
	^false
]

{ #category : #attributes }
GlorpClassModel >> newAttributeNamed: aSymbol [
	^self addAttribute: (GlorpAttributeModel named: aSymbol)
]

{ #category : #attributes }
GlorpClassModel >> newAttributeNamed: aSymbol collection: collectionClass of: aClass [
	^self addAttribute: (GlorpAttributeModel named: aSymbol collection: collectionClass of: aClass)
]

{ #category : #attributes }
GlorpClassModel >> newAttributeNamed: aSymbol collectionOf: aClass [
	^self addAttribute: (GlorpAttributeModel named: aSymbol collectionOf: aClass)
]

{ #category : #attributes }
GlorpClassModel >> newAttributeNamed: aSymbol dictionaryFrom: keyClass to: valueClass [
	^self addAttribute: (GlorpAttributeModel named: aSymbol dictionaryFrom: keyClass to: valueClass)
]

{ #category : #attributes }
GlorpClassModel >> newAttributeNamed: aSymbol type: aClass [
	^self addAttribute: (GlorpAttributeModel named: aSymbol type: aClass)
]

{ #category : #printing }
GlorpClassModel >> printOn: aStream [
	aStream nextPutAll: '~~'.
	self describedClass isNil ifFalse: [aStream nextPutAll: self describedClass name].
	aStream nextPutAll: '~~'
]

{ #category : #accessing }
GlorpClassModel >> system [
	^system
]

{ #category : #accessing }
GlorpClassModel >> system: aDescriptorSystem [
	system := aDescriptorSystem
]

{ #category : #validation }
GlorpClassModel >> validateIn: aDescriptorSystem [ 
	attributes do: [:each | each validate]
]
