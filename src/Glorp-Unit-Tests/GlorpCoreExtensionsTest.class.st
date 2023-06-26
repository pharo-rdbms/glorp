Class {
	#name : #GlorpCoreExtensionsTest,
	#superclass : #GlorpTestCase,
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #tests }
GlorpCoreExtensionsTest >> testGlorpIsCollection [

	self deny: Object new glorpIsCollection.
	self assert: Collection new glorpIsCollection
]
