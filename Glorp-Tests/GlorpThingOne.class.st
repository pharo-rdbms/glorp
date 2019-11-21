"
This just exists to be put in collections.

Instance Variables:
	id	<SmallInteger>	description of id
	name	<String>	description of name


"
Class {
	#name : #GlorpThingOne,
	#superclass : #Object,
	#instVars : [
		'id',
		'name'
	],
	#category : 'Glorp-Tests-CollectionTypeModels'
}

{ #category : #'*Glorp-Tests' }
GlorpThingOne class >> named: aString [
	^self new name: aString.
]

{ #category : #comparing }
GlorpThingOne >> <= aThingOne [
	^self name <= aThingOne name.
]

{ #category : #accessing }
GlorpThingOne >> id [
	^id
]

{ #category : #accessing }
GlorpThingOne >> id: anInteger [
	id := anInteger
]

{ #category : #accessing }
GlorpThingOne >> name [
	^name
]

{ #category : #accessing }
GlorpThingOne >> name: aString [
	name := aString
]
