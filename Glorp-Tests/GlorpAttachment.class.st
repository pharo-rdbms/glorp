Class {
	#name : #GlorpAttachment,
	#superclass : #Object,
	#instVars : [
		'index',
		'mimeType',
		'attachmentBytes'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpAttachment class >> glorpSetupClassModel: model forSystem: system [ 
	model
		newAttributeNamed: #index;
		newAttributeNamed: #mimeType;
		newAttributeNamed: #attachmentBytes type: GlorpAttachmentBytes
]

{ #category : #'as yet unclassified' }
GlorpAttachment class >> glorpSetupDescriptor: aDesc forSystem: system [ 
	| t |
	t := system tableNamed: 'attachment'.
	aDesc table: t.
	(aDesc newMapping: DirectMapping) from: #index
		to: (t fieldNamed: 'indexInDocument').
	(aDesc newMapping: DirectMapping) from: #mimeType
		to: (t fieldNamed: 'mimetype').
	(aDesc newMapping: OneToOneMapping) attributeName: #attachmentBytes
]

{ #category : #accessing }
GlorpAttachment >> attachmentBytes [
	^attachmentBytes
]

{ #category : #accessing }
GlorpAttachment >> attachmentBytes: anObject [
	attachmentBytes := anObject
]

{ #category : #accessing }
GlorpAttachment >> index [
	^index
]

{ #category : #accessing }
GlorpAttachment >> index: anObject [
	index := anObject
]

{ #category : #accessing }
GlorpAttachment >> mimeType [
	^mimeType
]

{ #category : #accessing }
GlorpAttachment >> mimeType: anObject [
	mimeType := anObject
]
