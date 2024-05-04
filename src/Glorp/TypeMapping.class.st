"
TypeMappings are used to implement inheritance. They do not map to particular instance variables, but instead define things about the way the class is read. The default type mapping is IdentityTypeMapping, which does nothing. To use inheritance, substitute either a FilteredTypeMapping or a HorizontalTypeMapping. TypeMappings become part of a TypeResolver, which keeps the information for a class and its subclasses, each of which will have a typeMapping specific to that class.

Subclasses must implement the following messages:
	testing
		isAbstract


"
Class {
	#name : 'TypeMapping',
	#superclass : 'Mapping',
	#category : 'Glorp-Mappings',
	#package : 'Glorp',
	#tag : 'Mappings'
}

{ #category : 'mapping' }
TypeMapping >> addTypeMappingCriteriaTo: collection in: expression [
	^self
]

{ #category : 'mapping' }
TypeMapping >> allDescribedConcreteClasses [

	^Array with: (self describedClass)
]

{ #category : 'testing' }
TypeMapping >> canBeTypeMappingParent [
	^true
]

{ #category : 'mapping' }
TypeMapping >> describedClass [
	^self descriptor describedClass
]

{ #category : 'mapping' }
TypeMapping >> describedConcreteClassFor: aRow withBuilder: builder [

	^self mappedClass
]

{ #category : 'mapping' }
TypeMapping >> descriptorForSuperclass [
	^self system descriptorFor: self mappedClass superclass
]

{ #category : 'testing' }
TypeMapping >> hasAttribute [
	"Return true if this maps an attribute, which is normally true"
	^false
]

{ #category : 'testing' }
TypeMapping >> isAbstract [
	self subclassResponsibility
]

{ #category : 'testing' }
TypeMapping >> isRelationship [

	^false.
]

{ #category : 'testing' }
TypeMapping >> isTypeMapping [
	^true
]

{ #category : 'testing' }
TypeMapping >> isTypeMappingRoot [
	| superClassDescriptor |
	superClassDescriptor := self descriptorForSuperclass.
	^superClassDescriptor isNil or: [ superClassDescriptor typeMapping canBeTypeMappingParent not ]
]

{ #category : 'mapping' }
TypeMapping >> mapFromObject: anObject intoRowsIn: aRowMap [
	"do  nothing"
]

{ #category : 'mapping' }
TypeMapping >> mapObject: anObject inElementBuilder: anElementBuilder [
	"do  nothing"
]

{ #category : 'accessing' }
TypeMapping >> mappedClass [
	^self descriptor describedClass
]

{ #category : 'mapping' }
TypeMapping >> referencedIndependentObjectsFrom: anObject [
	^#().
]

{ #category : 'mapping' }
TypeMapping >> typeMappingRoot [
	^self isTypeMappingRoot 
		ifTrue: [self mappedClass]
		ifFalse: [self descriptorForSuperclass typeMapping typeMappingRoot]
]

{ #category : 'validation' }
TypeMapping >> validateAttribute [
	" TypeMapping doesn't use the attribute, validation would therefore fail. Probably should introduce AttributeMapping as sibling to TypeMapping "
]
