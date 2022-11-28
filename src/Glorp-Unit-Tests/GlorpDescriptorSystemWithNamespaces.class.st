Class {
	#name : #GlorpDescriptorSystemWithNamespaces,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpDescriptorSystemWithNamespaces >> allTableNames [
	^#()
]

{ #category : #accessing }
GlorpDescriptorSystemWithNamespaces >> constructAllClasses [
	^(super constructAllClasses)
		add: GlorpTestClassInNamespace;
		yourself
]

{ #category : #accessing }
GlorpDescriptorSystemWithNamespaces >> descriptorForGlorpTestClassInNamespace: aDescriptor [ 
	^aDescriptor
]
