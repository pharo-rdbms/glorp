"
Abstract 'worker' superclass object, named to avoid clash with more ordinary names for such a class.

Instance Variables
	id	<Integer>	
	name	<String>


"
Class {
	#name : #GlorpWorkingStiff,
	#superclass : #Object,
	#instVars : [
		'id',
		'name'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #comparing }
GlorpWorkingStiff >> = aWorkingStiff [
	^self class = aWorkingStiff class and: [id = aWorkingStiff id and: [name = aWorkingStiff name]].
]

{ #category : #accessing }
GlorpWorkingStiff >> id [
	^id
]

{ #category : #accessing }
GlorpWorkingStiff >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GlorpWorkingStiff >> name [
	^name
]

{ #category : #accessing }
GlorpWorkingStiff >> name: anObject [
	name := anObject
]
