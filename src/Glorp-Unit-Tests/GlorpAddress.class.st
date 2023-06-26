"
An address in the Bank model
"
Class {
	#name : #GlorpAddress,
	#superclass : #Object,
	#instVars : [
		'id',
		'street',
		'number'
	],
	#category : #'Glorp-Unit-Tests-Models - Bank'
}

{ #category : #examples }
GlorpAddress class >> example1 [

	^self new
		id: 1;
		street: 'West 47th Ave';
		number: '2042'.
]

{ #category : #examples }
GlorpAddress class >> example1WithChangedAddress [

	^self new
		id: 1;
		street: 'Garden of the Gods';
		number: '99999'.
]

{ #category : #examples }
GlorpAddress class >> example2 [

	^self new
		id: 2;
		street: 'Nowhere';
		number: '1000'
]

{ #category : #setup }
GlorpAddress class >> glorpSetupClassModel: aClassModel forSystem: aDescriptorSystem [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #street.
	aClassModel newAttributeNamed: #number
]

{ #category : #setup }
GlorpAddress class >> glorpSetupDescriptor: aDescriptor forSystem: aDescriptorSystem [
	| table |
	table := aDescriptorSystem tableNamed: 'GR_ADDRESS'.
	aDescriptor table: table.
	aDescriptor
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID'));
		addMapping: (DirectMapping from: #street to: (table fieldNamed: 'STREET'));
		addMapping: (DirectMapping from: #number to: (table fieldNamed: 'HOUSE_NUM'))
]

{ #category : #notification }
GlorpAddress >> glorpNoticeOfExpiryIn: aSession [
]

{ #category : #accessing }
GlorpAddress >> id [
	"Private - Answer the value of the receiver's ''id'' instance variable."

	^ id
]

{ #category : #accessing }
GlorpAddress >> id: anObject [
	"Private - Set the value of the receiver's ''id'' instance variable to the argument, anObject."

	id := anObject
]

{ #category : #accessing }
GlorpAddress >> number [
	"Private - Answer the value of the receiver's ''number'' instance variable."

	^ number
]

{ #category : #accessing }
GlorpAddress >> number: anObject [
	"Private - Set the value of the receiver's ''number'' instance variable to the argument, anObject."

	number := anObject
]

{ #category : #printing }
GlorpAddress >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll:
		'(' , id printString , ',' , street printString , ','
		, number printString , ')'
]

{ #category : #accessing }
GlorpAddress >> street [
	"Private - Answer the value of the receiver's ''street'' instance variable."

	^ street
]

{ #category : #accessing }
GlorpAddress >> street: anObject [
	"Private - Set the value of the receiver's ''street'' instance variable to the argument, anObject."

	street := anObject
]
