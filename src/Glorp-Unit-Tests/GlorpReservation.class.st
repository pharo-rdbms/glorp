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

{ #category : #examples }
GlorpReservation class >> example1 [

	^self new
		id: 2;
		passenger: GlorpPassenger example1.
]

{ #category : #examples }
GlorpReservation class >> example2 [

	^self new
		id: 7;
		passenger: GlorpPassenger example2
]

{ #category : #accessing }
GlorpReservation >> id [
	^id
]

{ #category : #accessing }
GlorpReservation >> id: anInteger [
	id := anInteger
]

{ #category : #initialization }
GlorpReservation >> initialize [

	super initialize.
	passengers := OrderedCollection new
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
