"
Timestamp type
"
Class {
	#name : 'GlorpTimeStampType',
	#superclass : 'GlorpDatabaseType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'converting' }
GlorpTimeStampType >> converterForStType: aClass [
	aClass = Date ifTrue: [^self platform converterNamed: #timestampToDate].
	^self platform converterNamed: #timestamp.
]

{ #category : 'converting' }
GlorpTimeStampType >> impliedSmalltalkType [
	^Dialect timestampClass.
]

{ #category : 'SQL' }
GlorpTimeStampType >> print: aValue on: aStream [
	"SQL in Oracle and SQLServer (which use type timestamp for dates as well as timestamps) supports adding an integer to a date, meaning incrementing the date by that number of days.  A bound integer value will go directly to the database layer;  an unbound value will go through here."

	aValue isInteger ifTrue: [^self platform integer print: aValue on: aStream].
	self platform printTimestamp: aValue on: aStream for: self.
]
