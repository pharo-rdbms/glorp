"
This is a trivial type resolver (and the default one) that just uses a single class, with no inheritance.
"
Class {
	#name : #IdentityTypeResolver,
	#superclass : #TypeResolver,
	#category : 'Glorp-Mappings'
}

{ #category : #accessing }
IdentityTypeResolver >> allTablesFor: aDescriptor [
	"Return all tables used by this descriptor or its subclasses. For a non-inheritance descriptor, this is the same as tables."
	^aDescriptor tables
]

{ #category : #'type resolution' }
IdentityTypeResolver >> classesRequiringIndependentQueriesFor: aClass [
	^Array with: aClass
]

{ #category : #accessing }
IdentityTypeResolver >> describedConcreteClassFor: aRow withBuilder: builder descriptor: aDescriptor [
	^aDescriptor describedClass
]

{ #category : #accessing }
IdentityTypeResolver >> descriptorsRequiringIndependentQueriesFor: aClass [
	^members
]

{ #category : #accessing }
IdentityTypeResolver >> typeMappingRootDescriptor [
	^members first
]
