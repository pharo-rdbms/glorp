Class {
	#name : #GlorpPerson,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'address',
		'emailAddresses',
		'hasEmail'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #examples }
GlorpPerson class >> example1 [

	^self new
		id: 1;
		name: 'Zaphod Beeblebrox';
		address: GlorpAddress example1.
]

{ #category : #examples }
GlorpPerson class >> example1WithChangedAddress [

	^self new
		id: 1;
		name: 'Zaphod Beeblebrox';
		address: GlorpAddress example1WithChangedAddress.
]

{ #category : #examples }
GlorpPerson class >> example1WithDifferentAddress [

	^self new
		id: 1;
		name: 'Zaphod Beeblebrox';
		address: GlorpAddress example2.
]

{ #category : #examples }
GlorpPerson class >> example1WithDifferentName [

	^self new
		id: 1; 
		name: 'John Doe';
		address: GlorpAddress example1.
]

{ #category : #examples }
GlorpPerson class >> example1WithNoAddress [

	^self new
		id: 1;
		name: 'Zaphod Beeblebrox';
		address: nil.
]

{ #category : #examples }
GlorpPerson class >> example2 [

	^self new
		id: 2;
		name: 'John Doe';
		address: GlorpAddress example2.
]

{ #category : #accessing }
GlorpPerson >> address [
	"Private - Answer the value of the receiver's ''address'' instance variable."

	^address
]

{ #category : #accessing }
GlorpPerson >> address: anObject [
	"Private - Set the value of the receiver's ''address'' instance variable to the argument, anObject."

	address := anObject
]

{ #category : #accessing }
GlorpPerson >> emailAddresses [
	^emailAddresses
]

{ #category : #accessing }
GlorpPerson >> emailAddresses: aCollection [
	emailAddresses := aCollection
]

{ #category : #accessing }
GlorpPerson >> hasEmail [
	^hasEmail
]

{ #category : #accessing }
GlorpPerson >> hasEmail: aBoolean [
	hasEmail := aBoolean
]

{ #category : #accessing }
GlorpPerson >> id [
	"Private - Answer the value of the receiver's ''id'' instance variable."

	^id
]

{ #category : #accessing }
GlorpPerson >> id: anObject [
	"Private - Set the value of the receiver's ''id'' instance variable to the argument, anObject."

	id := anObject
]

{ #category : #accessing }
GlorpPerson >> name [
	"Private - Answer the value of the receiver's ''name'' instance variable."

	^name
]

{ #category : #accessing }
GlorpPerson >> name: anObject [
	"Private - Set the value of the receiver's ''name'' instance variable to the argument, anObject."

	name := anObject
]

{ #category : #printing }
GlorpPerson >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: id printString, ',', (name ifNil: ['']).
	aStream nextPutAll: ')'.
]
