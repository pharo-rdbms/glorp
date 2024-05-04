"
This is the default type mapping for classes that aren't using inheritance. It implements all of the protocol as no-ops.
"
Class {
	#name : 'IdentityTypeMapping',
	#superclass : 'TypeMapping',
	#category : 'Glorp-Mappings',
	#package : 'Glorp',
	#tag : 'Mappings'
}

{ #category : 'testing' }
IdentityTypeMapping >> canBeTypeMappingParent [
	^false
]

{ #category : 'testing' }
IdentityTypeMapping >> isAbstract [
	^false
]

{ #category : 'testing' }
IdentityTypeMapping >> isTypeMappingRoot [
	^true
]

{ #category : 'mapping' }
IdentityTypeMapping >> mappedFields [
	^#()
]

{ #category : 'mapping' }
IdentityTypeMapping >> trace: aTracing context: anExpression [
	"do nothing"
]
