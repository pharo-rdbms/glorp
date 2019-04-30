"
The GlorpTravelFolder and GlorpTravelFile test classes are not (at time of creation) connected to GlorpTravelAgent and the other long-established Glorp test classes;  they have a separate descriptor system, etc..  Their names were chosen just to make it obvious that they are also test objects.
"
Class {
	#name : #GlorpTravelFile,
	#superclass : #Object,
	#instVars : [
		'id',
		'name'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #accessing }
GlorpTravelFile >> <= aTravelFile [
	^self name <= aTravelFile name.
]

{ #category : #accessing }
GlorpTravelFile >> id [

	^id
]

{ #category : #accessing }
GlorpTravelFile >> id: anObject [

	id := anObject
]

{ #category : #accessing }
GlorpTravelFile >> name [

	^name
]

{ #category : #accessing }
GlorpTravelFile >> name: anObject [

	name := anObject
]
