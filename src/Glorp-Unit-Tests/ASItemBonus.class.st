"
An item bonus in the AnySatisfy model
"
Class {
	#name : #ASItemBonus,
	#superclass : #Object,
	#instVars : [
		'item',
		'bonus'
	],
	#category : #'Glorp-Unit-Tests-Models - AnySatisfy'
}

{ #category : #accessing }
ASItemBonus >> bonus [

	^ bonus
]

{ #category : #accessing }
ASItemBonus >> bonus: anObject [

	bonus := anObject
]

{ #category : #accessing }
ASItemBonus >> item [

	^ item
]

{ #category : #accessing }
ASItemBonus >> item: anObject [

	item := anObject
]
