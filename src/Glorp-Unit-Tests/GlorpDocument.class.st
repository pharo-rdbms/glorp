Class {
	#name : #GlorpDocument,
	#superclass : #Object,
	#instVars : [
		'id',
		'whatever',
		'attachments'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #setup }
GlorpDocument class >> glorpSetupClassModel: model forSystem: system [ 
	model
		newAttributeNamed: #id;
		newAttributeNamed: #whatever;
		newAttributeNamed: #attachments
			collection: OrderedCollection
			of: GlorpAttachment
]

{ #category : #setup }
GlorpDocument class >> glorpSetupDescriptor: aDesc forSystem: system [ 
	| t |
	t := system tableNamed: 'document'.
	aDesc table: t.
	(aDesc newMapping: DirectMapping) from: #id to: (t fieldNamed: 'id').
	(aDesc newMapping: DirectMapping) from: #whatever to: (t fieldNamed: 'whatever').
	(aDesc newMapping: OneToManyMapping)
		attributeName: #attachments;
		orderBy: [:ea | ea index]
]

{ #category : #accessing }
GlorpDocument >> attachments [
	^attachments
]

{ #category : #accessing }
GlorpDocument >> attachments: anObject [
	attachments := anObject
]

{ #category : #accessing }
GlorpDocument >> id [
	^id
]

{ #category : #accessing }
GlorpDocument >> id: anObject [
	id := anObject
]

{ #category : #initialization }
GlorpDocument >> initialize [

	super initialize.
	attachments := OrderedCollection new.
	whatever := 3
]
