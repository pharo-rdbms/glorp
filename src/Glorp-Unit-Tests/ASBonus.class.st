Class {
	#name : #ASBonus,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'credits'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'as yet unclassified' }
ASBonus class >> new [
	"Answer a newly created and initialized instance."

	^super new initialize
]

{ #category : #accessing }
ASBonus >> credits [

	^credits
]

{ #category : #accessing }
ASBonus >> credits: anObject [

	credits := anObject
]

{ #category : #accessing }
ASBonus >> id [

	^id
]

{ #category : #accessing }
ASBonus >> id: anObject [

	id := anObject
]

{ #category : #'initialize-release' }
ASBonus >> initialize [
	"Initialize a newly created instance. This method must answer the receiver."

	super initialize.
	" *** Edit the following to properly initialize instance variables ***"
	name := nil.
	credits := nil.
	" *** And replace this comment with additional initialization code *** "
	^self
]

{ #category : #accessing }
ASBonus >> name [

	^name
]

{ #category : #accessing }
ASBonus >> name: anObject [

	name := anObject
]
