"
Time with TimeZone type for Postgress
"
Class {
	#name : #GlorpPGTimeWithTimeZoneType,
	#superclass : #GlorpDatabaseType,
	#category : #'Glorp-Types'
}

{ #category : #converting }
GlorpPGTimeWithTimeZoneType >> converterForStType: aClass [
	"Convert as though we were a regular time field, since our Smalltalk object has no time zone information."

	^self platform converterNamed: #time.
]

{ #category : #converting }
GlorpPGTimeWithTimeZoneType >> impliedSmalltalkType [
	^Time
]

{ #category : #initialize }
GlorpPGTimeWithTimeZoneType >> initialize [
	super initialize.
	typeString := 'TIME WITH TIME ZONE'.
]

{ #category : #SQL }
GlorpPGTimeWithTimeZoneType >> print: aValue on: aStream [
	"Print as though we were a regular time field, since our Smalltalk object has no time zone information."

	self platform time print: aValue on: aStream.
]
