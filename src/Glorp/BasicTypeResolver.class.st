"
This is an abstract superclass for TypeResolvers that do inheritance in some form.

Instance Variables:
	concreteMembers	<(Collection of: (Descriptor))>	Which of our members can actually be instantiated, as opposed to abstract superclasses.
	rootClass	<Behavior>	Which is the root class of the inheritance hierarchy we represent.
	rootDescriptor	<Descriptor>	The descriptor for the root class
	subclassDescriptorsBuilt	<Boolean>	Have we asked the system for the descriptors for all of the root's subclasses yet?


"
Class {
	#name : 'BasicTypeResolver',
	#superclass : 'TypeResolver',
	#instVars : [
		'concreteMembers',
		'subclassDescriptorsBuilt',
		'rootDescriptor',
		'rootClass'
	],
	#category : 'Glorp-Mappings',
	#package : 'Glorp',
	#tag : 'Mappings'
}

{ #category : 'private' }
BasicTypeResolver >> allDescribedConcreteClasses [
	self subclassDescriptorsBuilt ifFalse: [self forceSubclassDescriptorLoads].
	^self concreteMembers collect: [ :each | each describedClass ]
]

{ #category : 'accessing' }
BasicTypeResolver >> concreteMembers [
	^concreteMembers isNil 
		ifTrue: [ concreteMembers := OrderedCollection new ]
		ifFalse: [ concreteMembers]
]

{ #category : 'private' }
BasicTypeResolver >> forceSubclassDescriptorLoads [
	self rootClass allSubclassesDo: [ :each | self system descriptorFor: each ].
	subclassDescriptorsBuilt := true
]

{ #category : 'registering' }
BasicTypeResolver >> register: aDescriptor abstract: abstract [

	super register: aDescriptor abstract: abstract.
	abstract ifFalse: [ self concreteMembers add: aDescriptor ]
]

{ #category : 'accessing' }
BasicTypeResolver >> rootClass [
	^rootClass
]

{ #category : 'accessing' }
BasicTypeResolver >> rootClass: anObject [
	rootClass := anObject
]

{ #category : 'accessing' }
BasicTypeResolver >> rootDescriptor [
	^rootDescriptor isNil
		ifTrue: [ rootDescriptor := self system descriptorFor: self rootClass ]
		ifFalse: [ rootDescriptor ]
]

{ #category : 'other' }
BasicTypeResolver >> rootDescriptor: anObject [
	rootDescriptor := anObject
]

{ #category : 'accessing' }
BasicTypeResolver >> subclassDescriptorsBuilt [
	^subclassDescriptorsBuilt isNil
		ifTrue: [ subclassDescriptorsBuilt := false ]
		ifFalse: [ subclassDescriptorsBuilt ]
]

{ #category : 'type resolution' }
BasicTypeResolver >> typeMappingRootDescriptor [
	^self rootDescriptor
]

{ #category : 'testing' }
BasicTypeResolver >> usesInheritance [
	^true
]

{ #category : 'validation' }
BasicTypeResolver >> validate [
	| tables sequences |
	super validate.
	tables := self concreteMembers collect: [:each | each primaryTable].
	sequences := tables inject: #() into: [:sum :each | sum, ((each primaryKeyFields) collect: [:eachField | eachField type sequence])].
	sequences := sequences reject: #isNil.
	sequences asSet size > 1 ifTrue: [self error: 'When using inheritance, all tables must use the same sequence. Otherwise, the primary key references will be ambiguous.']
]
