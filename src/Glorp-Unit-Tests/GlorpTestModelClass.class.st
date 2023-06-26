"
An abstract superclass providing convenience methods for domain objects to facilitate testing.
"
Class {
	#name : #GlorpTestModelClass,
	#superclass : #TestAsserter,
	#category : #'Glorp-Unit-Tests-Models - Trade'
}

{ #category : #testing }
GlorpTestModelClass class >> isAbstract [

	^ self == GlorpTestModelClass
]
