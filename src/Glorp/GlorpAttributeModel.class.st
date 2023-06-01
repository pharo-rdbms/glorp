"
This is the metadata for an individual instance variable. It will be held in a GlorpClassModel, and used for accessing the variable when building or writing out objects.

Instance Variables:
	attributeIndex	<Integer>	What is the index in the class of the instance variable. Used if we are using instVarAt: to get values.
	classModel	<GlorpClassModel>	The class model that contains us.
	collectionType	<Class>	If we are an attribute that holds a collection, what is the class of the collection.
	keyType	<Class>	If we represent a dictionary attribute, what is the type of our key (type will be used for the type of the value).
	name	<Symbol>	The name of the attribute/instance variable.
	setSelector	<Symbol>	If we are using message access to get/set values, what is the selector to use for setting. Defaults to name, ':'.
	type	<Class>	The class containing this instance variable
	useDirectAccess	<Boolean>	If true (the default) we use instVarAt:/instVarAt:put: to access the attribute values.


"
Class {
	#name : #GlorpAttributeModel,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'collectionType',
		'keyType',
		'classModel',
		'attributeIndex',
		'useDirectAccess',
		'setSelector',
		'canRead',
		'canWrite'
	],
	#category : #'Glorp-Mappings'
}

{ #category : #'instance creation' }
GlorpAttributeModel class >> named: aSymbol [
	^self new name: aSymbol
]

{ #category : #'instance creation' }
GlorpAttributeModel class >> named: aSymbol collection: aCollectionClass of: aClass [
	^(self new)
		name: aSymbol;
		type: aClass;
		collectionType: aCollectionClass
]

{ #category : #'instance creation' }
GlorpAttributeModel class >> named: aSymbol collectionOf: aClass [
	^self named: aSymbol collection: OrderedCollection of: aClass
]

{ #category : #'instance creation' }
GlorpAttributeModel class >> named: aSymbol dictionary: dictionaryClass from: keyClass to: valueClass [
	^(self new)
		name: aSymbol;
		type: valueClass;
		keyType: keyClass;
		collectionType: dictionaryClass
]

{ #category : #'instance creation' }
GlorpAttributeModel class >> named: aSymbol dictionaryFrom: keyClass to: valueClass [
	^self named: aSymbol dictionary: Dictionary from: keyClass to: valueClass
]

{ #category : #'instance creation' }
GlorpAttributeModel class >> named: aSymbol type: aClass [
	^self new name: aSymbol; type: aClass
]

{ #category : #'instance creation' }
GlorpAttributeModel class >> new [
	^super new initialize
]

{ #category : #knitting }
GlorpAttributeModel >> add: anObject to: aCollection in: ourObject [
	"If this is an array we can't just add to it, we must concatenate and re-set the value"
	| newCollection |
	aCollection class == Array 
		ifTrue: [	
			newCollection := aCollection, (Array with: anObject).
			self setValueIn: ourObject to: newCollection.
			^self].
	(anObject class == Association and: [anObject key == nil])
		ifFalse: [aCollection add: anObject]
]

{ #category : #accessing }
GlorpAttributeModel >> beForPseudoVariable [
	"Make this be a pseudo-variable - one which is neither read nor written, and doesn't have a corresponding instance variable, but is only used for queries."
	canRead := false.
	canWrite := false
]

{ #category : #accessing }
GlorpAttributeModel >> canRead [
	^canRead
]

{ #category : #accessing }
GlorpAttributeModel >> canRead: aBoolean [
	canRead := aBoolean
]

{ #category : #accessing }
GlorpAttributeModel >> canWrite [
	^canWrite
]

{ #category : #accessing }
GlorpAttributeModel >> canWrite: aBoolean [
	canWrite := aBoolean
]

{ #category : #'get/set' }
GlorpAttributeModel >> checkTargetType: anObject [
	"Check that anObject's type corresponds to something we know how to handle for this attribute. We expect this to be a real object, not a collection."
	self checkTargetType: anObject against: self type
]

{ #category : #'get/set' }
GlorpAttributeModel >> checkTargetType: anObject against: aClass [
	"Check that anObject's type corresponds to aClass, which we expect as our values. We expect this to be a real object, not a collection."
	| targetModel |
	anObject yourSelf isNil ifTrue: [^self].
	aClass isNil ifTrue: [self error: 'No type to check against in class model'].
	anObject glorpIsCollection ifTrue: [(GlorpInvalidTypeError new object: anObject; expectedType: self collectionType) signal].
	targetModel := self system classModelFor: aClass.
	targetModel notNil ifTrue: [
		(targetModel matches: anObject)
			ifFalse: [(GlorpInvalidTypeError new object: anObject; expectedType: aClass) signal]]
]

{ #category : #'get/set' }
GlorpAttributeModel >> checkTargetTypeForKey: aKey value: anObject [
	"Check that anObject's type corresponds to something we know how to handle for this attribute. We expect this to be a real object, not a collection. This is the version used for checking a dictionary, where we check both key and value, but only if they correspond to mapped classes."
	(self system classModelFor: self keyType) isNil 
		ifFalse: [self checkTargetType: aKey against: self keyType].
	(self system classModelFor: self type) isNil
		ifFalse: [self checkTargetType: anObject against: type]
]

{ #category : #'get/set' }
GlorpAttributeModel >> checkType: anObject [
	(self classModel matches: anObject)
		ifFalse: [self error: 'Wrong type of object']
]

{ #category : #accessing }
GlorpAttributeModel >> classModel [
	^classModel
]

{ #category : #accessing }
GlorpAttributeModel >> classModel: aGlorpClassModel [
	classModel := aGlorpClassModel
]

{ #category : #accessing }
GlorpAttributeModel >> collectionType [
	^collectionType
]

{ #category : #accessing }
GlorpAttributeModel >> collectionType: aClass [
	collectionType := aClass
]

{ #category : #copying }
GlorpAttributeModel >> copyFrom: anAttributeModel [
	"Copy over the attributes if it defines them and we don't"
	anAttributeModel isNil ifTrue: [^self].
	self type isNil ifTrue: [self type: anAttributeModel type].
	self collectionType isNil
		ifTrue: [self collectionType: anAttributeModel collectionType].
	self privateUseDirectAccess isNil
		ifTrue: [useDirectAccess := anAttributeModel privateUseDirectAccess].
	canRead := anAttributeModel canRead.
	canWrite := anAttributeModel canWrite.
]

{ #category : #private }
GlorpAttributeModel >> directGetValueFrom: anObject [ 
	| index |
	index := self instVarIndexIn: anObject.
	index = 0 ifTrue: [self raiseInvalidAttributeError].
	^anObject instVarAt: index
]

{ #category : #private }
GlorpAttributeModel >> directSetValueIn: anObject to: aValue [ 
	| index |
	index := self instVarIndexIn: anObject.
	index = 0 ifTrue: [self raiseInvalidAttributeError].
	^anObject instVarAt: index put: aValue
]

{ #category : #'get/set' }
GlorpAttributeModel >> getValueFrom: anObject [
	| real |
	real := anObject yourSelf.
	self checkType: real.
	self useDirectAccess ifTrue: [^self directGetValueFrom: real].
	^real perform: self name
]

{ #category : #initialization }
GlorpAttributeModel >> initialize [
	canRead := true.
	canWrite := true
]

{ #category : #private }
GlorpAttributeModel >> instVarIndex [
	| soughtName |
	attributeIndex == nil ifFalse: [^attributeIndex].
	soughtName := Dialect instVarNameFor: name.
	^attributeIndex := self classModel describedClass allInstVarNames 
				indexOf: soughtName
]

{ #category : #private }
GlorpAttributeModel >> instVarIndexIn: anObject [ 
	^self instVarIndex
]

{ #category : #validation }
GlorpAttributeModel >> isCollectionAttribute [
	^collectionType notNil
]

{ #category : #mapping }
GlorpAttributeModel >> isDictionaryAttribute [
	^collectionType isBehavior and: [collectionType includesBehavior: Dictionary]
]

{ #category : #testing }
GlorpAttributeModel >> isForPseudoVariable [
	"Return true if this is a pseudo-variable - one which is neither read nor written, and doesn't have a corresponding instance variable, but is only used for queries."
	^(canRead not & canWrite not) or: [self isValid not]
]

{ #category : #validation }
GlorpAttributeModel >> isReadable [
	self canRead ifFalse: [^false].
	^self useDirectAccess 
		ifTrue: [self instVarIndex > 0]
		ifFalse: [self classModel describedClass canUnderstand: self name]
]

{ #category : #private }
GlorpAttributeModel >> isValid [
	^name notNil and: [classModel notNil]
]

{ #category : #validation }
GlorpAttributeModel >> isWritable [
	self canWrite ifFalse: [^false].
	^self useDirectAccess 
		ifTrue: [self instVarIndex > 0]
		ifFalse: [self classModel describedClass canUnderstand: self setSelector]
]

{ #category : #accessing }
GlorpAttributeModel >> keyType [
	^keyType
]

{ #category : #accessing }
GlorpAttributeModel >> keyType: aClass [
	keyType := aClass
]

{ #category : #knitting }
GlorpAttributeModel >> knit: ourObject to: anotherObject [ 
	"Set up the relationship from our object to another one, indicated by our mapping."

	self isCollectionAttribute 
		ifTrue: 
			[| collection |
			collection := self getValueFrom: ourObject.
			(collection isGlorpProxy and: [collection isInstantiated not]) 
				ifTrue: 
					[collection := self newCollection.
					self setValueIn: ourObject to: collection.
					self 
						add: anotherObject
						to: collection
						in: ourObject.
					^self].
			(collection includes: anotherObject) 
				ifFalse: 
					[self 
						add: anotherObject
						to: collection
						in: ourObject]]
		ifFalse: [self setValueIn: ourObject to: anotherObject]
]

{ #category : #mapping }
GlorpAttributeModel >> loopOver: mightBeACollection doing: aBlock [
	"It is possible that the value for a dictionary attribute is nil. If so, do not map it back"
	| index |
	self isCollectionAttribute ifFalse: [self checkTargetType: mightBeACollection. ^aBlock value: 1 value: mightBeACollection].
	mightBeACollection isNil ifTrue: [^nil].
	self isDictionaryAttribute ifTrue: [^mightBeACollection keysAndValuesDo: [:key :value |
		self checkTargetTypeForKey: key value: value. 
		value ifNotNil: [aBlock value: key value: value]]].
	index := 1.
	mightBeACollection glorpIsCollection ifFalse: [
		(GlorpInvalidTypeError new object: mightBeACollection; expectedType: self collectionType) signal].
	mightBeACollection
		do:
			[:each |
			| object | 
			object := each glorpRealObject. 
			self checkTargetType: object.
			aBlock value: index value: object.
			index := index + 1]
]

{ #category : #accessing }
GlorpAttributeModel >> name [
	^name isNil ifTrue: [''] ifFalse: [name]
]

{ #category : #accessing }
GlorpAttributeModel >> name: aSymbol [
	| symbol |
	symbol := aSymbol isNil ifTrue: [aSymbol] ifFalse: [aSymbol asSymbol].
	name := symbol
]

{ #category : #private }
GlorpAttributeModel >> newCollection [
	collectionType == GlorpVirtualCollection ifTrue: [^OrderedCollection new].
	^collectionType isBehavior ifTrue: [collectionType new] ifFalse: [collectionType copyEmpty].
]

{ #category : #printing }
GlorpAttributeModel >> printOn: aStream [
	aStream nextPutAll: self classModel printString, '>>', self name
]

{ #category : #private }
GlorpAttributeModel >> privateUseDirectAccess [
	^useDirectAccess
]

{ #category : #private }
GlorpAttributeModel >> raiseInvalidAttributeError [
	self error: 'Invalid attribute: ', classModel printString, '>>', name printString.
]

{ #category : #private }
GlorpAttributeModel >> setSelector [
	setSelector  == nil ifTrue: [setSelector := (name, ':') asSymbol].
	^setSelector.
]

{ #category : #'get/set' }
GlorpAttributeModel >> setValueIn: anObject to: aValue [ 
	| real |
	self isValid ifFalse: [^self].
	real := anObject yourSelf.
	self checkType: real.
	self useDirectAccess ifTrue: [^self directSetValueIn: real to: aValue].
	^real perform: self setSelector with: aValue
]

{ #category : #accessing }
GlorpAttributeModel >> system [
	classModel isNil ifTrue: [^nil].
	^classModel system.
]

{ #category : #accessing }
GlorpAttributeModel >> type [
	^type
]

{ #category : #accessing }
GlorpAttributeModel >> type: aClass [
	type := aClass
]

{ #category : #testing }
GlorpAttributeModel >> useDirectAccess [
	useDirectAccess isNil ifFalse: [^useDirectAccess].
	self system isNil ifTrue: [^true].  "A global default, although only applicable if we're not in a valid setup"
	^self system useDirectAccessForMapping.
]

{ #category : #accessing }
GlorpAttributeModel >> useDirectAccess: aBoolean [
	useDirectAccess := aBoolean
]

{ #category : #validation }
GlorpAttributeModel >> validate [
	name isEmpty ifTrue: [self error: 'Invalid attribute name']
]

{ #category : #validation }
GlorpAttributeModel >> validateCanRead [
	self isReadable ifFalse: [self raiseInvalidAttributeError]
]

{ #category : #validation }
GlorpAttributeModel >> validateCanWrite [
	self isWritable ifFalse: [self raiseInvalidAttributeError]
]
