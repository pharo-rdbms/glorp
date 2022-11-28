Class {
	#name : #GlorpReservation,
	#superclass : #Object,
	#instVars : [
		'id',
		'passenger',
		'passengers'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpReservation class >> example1 [

	^self new
		id: 2;
		passenger: GlorpPassenger example1.
]

{ #category : #'as yet unclassified' }
GlorpReservation class >> example2 [

	^self new
		id: 7;
		passenger: GlorpPassenger example2.
]

{ #category : #'as yet unclassified' }
GlorpReservation class >> new [
	^super new initialize.
]

{ #category : #accessing }
GlorpReservation >> id [
	^id
]

{ #category : #accessing }
GlorpReservation >> id: anInteger [
	id := anInteger
]

{ #category : #'initialize/release' }
GlorpReservation >> initialize [
	passengers := OrderedCollection new.
]

{ #category : #accessing }
GlorpReservation >> passenger [
	^passenger
]

{ #category : #accessing }
GlorpReservation >> passenger: aPassenger [
	passenger := aPassenger.
	passengers add: aPassenger.
]

{ #category : #accessing }
GlorpReservation >> passengers [
	^passengers
]

{ #category : #accessing }
GlorpReservation >> passengers: aCollection [
	passengers := aCollection.
]
