"
This is an abstract superclass for GLORP exceptions.

"
Class {
	#name : 'GlorpError',
	#superclass : 'Error',
	#classVars : [
		'Announcements'
	],
	#category : 'Glorp-Exceptions',
	#package : 'Glorp',
	#tag : 'Exceptions'
}

{ #category : 'exception compatibility' }
GlorpError class >> ancestorOf: anExceptionThingy [
	"VA Compatibility"
	^self exceptionalEvent handles: anExceptionThingy
]

{ #category : 'exception compatibility' }
GlorpError class >> description [
	"For ObjectStudio"
	^super description.
]

{ #category : 'exception compatibility' }
GlorpError class >> mayResume [
	"This is a VisualWorks convention. Reimplement this here so that it will also be found in other dialects that don't have it in the superclass."
	^false
]

{ #category : 'exception compatibility' }
GlorpError class >> signal [
	^self new signal.
]

{ #category : 'exception compatibility' }
GlorpError class >> signal: aString [
	^self new signal: aString.
]

{ #category : 'testing' }
GlorpError >> ancestorOf: anExceptionThingy [
	"VA Compatibility"

	^ self handles: anExceptionThingy
]

{ #category : 'accessing' }
GlorpError >> databaseError [
	"rh 8/1/2004 21:26 for #getMessageText"

	^ self class name
]

{ #category : 'accessing' }
GlorpError >> description [
	"Make sure that we've populated our messageText before calling the superclass implementation."

	self getMessageText.
	^ super description
]

{ #category : 'accessing' }
GlorpError >> getMessageText [

	^ self databaseError
]

{ #category : 'private - testing' }
GlorpError >> isResumable [

	^ self class mayResume
]

{ #category : 'accessing' }
GlorpError >> messageText [

	(messageText isNil or: [ messageText isEmpty ]) ifTrue: [
		messageText := self getMessageText ].
	^ messageText
]

{ #category : 'accessing' }
GlorpError >> session [
	"We don't know what our session is, return nil by default."

	^ nil
]
