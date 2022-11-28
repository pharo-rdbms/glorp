"
TypeResolvers are used to implement inheritance. Each descriptor has a type resolver, which can be asked for the types associated with that descriptor. By default we get an IdentityTypeResolver, which just gives us a single class. With inheritance we can get different types.

Subclasses must implement the following messages:
	accessing
		classesRequiringIndependentQueriesFor:
		describedConcreteClassFor:withBuilder:descriptor:
	type resolution
		typeMappingRootDescriptor

Instance Variables:
	members	<(SequenceableCollection of: (Descriptor))>	The descriptors of the classes that this resolver applies to.
	system	<DescriptorSystem>	The system in which the members live.


"
Class {
	#name : #TypeResolver,
	#superclass : #Object,
	#instVars : [
		'members',
		'system'
	],
	#category : 'Glorp-Mappings'
}

{ #category : #accessing }
TypeResolver >> addMember: aDescriptor [
	members isNil ifTrue: [members := OrderedCollection new].
	(members includes: aDescriptor)
		ifFalse: [members add: aDescriptor]
		ifTrue: [Transcript cr; show: ('Your system does a duplicate registration of ', aDescriptor printString, ' in ', self printString)]
]

{ #category : #accessing }
TypeResolver >> allTablesFor: aDescriptor [
	"Return all tables used by this descriptor or its subclasses. For a non-inheritance descriptor, this is the same as tables."
	self subclassResponsibility
]

{ #category : #accessing }
TypeResolver >> classesRequiringIndependentQueriesFor: aClass [
	self subclassResponsibility
]

{ #category : #other }
TypeResolver >> describedClasses [
	^members collect: [:each | each describedClass ]
]

{ #category : #accessing }
TypeResolver >> describedConcreteClassFor: row withBuilder: builder descriptor: aDescriptor [
	self subclassResponsibility
]

{ #category : #'type resolution' }
TypeResolver >> fieldsForSelectStatement [
	"Return fields that are needed in a select statement - i.e. return all inherited fields that are part of the tables we are already selecting for this object"
	^#()
]

{ #category : #registering }
TypeResolver >> register: aDescriptor [
	^self register: aDescriptor abstract: false
]

{ #category : #registering }
TypeResolver >> register: aDescriptor abstract: abstract [

	self system: aDescriptor system.
	self addMember: aDescriptor.
	aDescriptor typeResolver: self
]

{ #category : #'query setup' }
TypeResolver >> setUpExpressionsForQuery: aQuery [
	"A hook to let us do any modifications to the query that we need."
	^self
]

{ #category : #accessing }
TypeResolver >> shouldUseSingleQuery [
	"Return true if we should attempt to combine queries for multiple subclasses in disjoint tables into one."
	^false
]

{ #category : #testing }
TypeResolver >> supportsOrderingFor: aDescriptor [
	^true
]

{ #category : #accessing }
TypeResolver >> system [
	^system
]

{ #category : #accessing }
TypeResolver >> system: anObject [
	system := anObject
]

{ #category : #'type resolution' }
TypeResolver >> typeMappingRootDescriptor [
	self subclassResponsibility
]

{ #category : #testing }
TypeResolver >> usesInheritance [
	^false
]

{ #category : #validation }
TypeResolver >> validate [
	^self
]
