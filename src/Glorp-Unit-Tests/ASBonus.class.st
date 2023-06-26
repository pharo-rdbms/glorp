"
A bonus in the AnySatisfy model
"
Class {
	#name : #ASBonus,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'credits'
	],
	#category : #'Glorp-Unit-Tests-Models - AnySatisfy'
}

{ #category : #accessing }
ASBonus >> credits [

	^ credits
]

{ #category : #accessing }
ASBonus >> credits: anObject [

	credits := anObject
]

{ #category : #accessing }
ASBonus >> id [

	^ id
]

{ #category : #accessing }
ASBonus >> id: anObject [

	id := anObject
]

{ #category : #accessing }
ASBonus >> name [

	^ name
]

{ #category : #accessing }
ASBonus >> name: anObject [

	name := anObject
]
