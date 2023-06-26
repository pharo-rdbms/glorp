Class {
	#name : #ASItem,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'bonuses'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
ASItem >> bonuses [

	^bonuses
]

{ #category : #accessing }
ASItem >> bonuses: anObject [

	bonuses := anObject
]

{ #category : #accessing }
ASItem >> id [

	^id
]

{ #category : #accessing }
ASItem >> id: anObject [

	id := anObject
]

{ #category : #initialization }
ASItem >> initialize [

	super initialize.
	bonuses := OrderedCollection new
]

{ #category : #accessing }
ASItem >> name [

	^name
]

{ #category : #accessing }
ASItem >> name: anObject [

	name := anObject
]
