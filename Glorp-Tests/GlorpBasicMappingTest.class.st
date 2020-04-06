Class {
	#name : #GlorpBasicMappingTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'mapping',
		'person'
	],
	#category : 'Glorp-Tests-Tests'
}

{ #category : #support }
GlorpBasicMappingTest >> setUp [

	super setUp.
	mapping := DirectMapping new.
	mapping attributeName: #id.
	mapping attribute classModel describedClass: GlorpPerson.
	person := GlorpPerson example1.
]

{ #category : #tests }
GlorpBasicMappingTest >> testGet [
	
	self assert: (mapping getValueFrom: person) = 1
]

{ #category : #tests }
GlorpBasicMappingTest >> testSet [
	
	mapping setValueIn: person to: 2.
	self assert: person id = 2.
	self assert: (mapping getValueFrom: person) = 2.
]
