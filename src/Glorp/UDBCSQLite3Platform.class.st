"
I support Glorp's use of the SQLite database through NBSQLite3, the NativeBoost interface to SQLite for Pharo Smalltalk.
"
Class {
	#name : 'UDBCSQLite3Platform',
	#superclass : 'SQLite3Platform',
	#category : 'Glorp-Platforms',
	#package : 'Glorp',
	#tag : 'Platforms'
}

{ #category : 'types' }
UDBCSQLite3Platform >> boolean [
	"Booleans are represented as integers within the database, but converted to Booleans by the driver"

	^self typeNamed: #boolean ifAbsentPut: [GlorpBooleanType new typeString: 'boolean'].
]

{ #category : 'conversion - boolean' }
UDBCSQLite3Platform >> convertIntegerToBoolean: anInteger for: aType [

	"UDBC SQLite transparently returns Smalltalk true/false/nil for SQL columns declared as boolean."
	^ (anInteger isKindOf: Boolean)
		ifTrue: [ anInteger ]
		ifFalse: [ super convertIntegerToBoolean: anInteger for: aType ]

]

{ #category : 'testing' }
UDBCSQLite3Platform >> isUDBCSQLite3Platform [
	^ true
]

{ #category : 'conversion - times' }
UDBCSQLite3Platform >> printDate: aTimestamp isoFormatOn: stream [
	"Print the date as yyyy-mm-dd"

	| monthNumber dayOfMonth |
	aTimestamp ifNil: [ ^ 'NULL' ].
	stream nextPut: $".
	aTimestamp year printOn: stream.
	stream nextPut: $-.
	monthNumber := aTimestamp monthIndex.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: monthNumber).
	stream nextPut: $-.
	dayOfMonth := aTimestamp dayOfMonth.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: dayOfMonth).
	stream nextPut: $"
]

{ #category : 'conversion - times' }
UDBCSQLite3Platform >> printTime: aTimeString for: aType [
	
	aTimeString isNil ifTrue: [^'NULL'].
	^ String streamContents: [ :str |
		str nextPut: $".
		aTimeString printOn: str.
		str nextPut: $" ]

]

{ #category : 'conversion - times' }
UDBCSQLite3Platform >> printTime: aTimestamp isoFormatOn: stream milliseconds: aBoolean [
	"Print the time as hh:mm:ss.mmm"
	| ms |
	aTimestamp isNil ifTrue: [^nil].
	stream nextPut: $".
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: aTimestamp hours).
	stream nextPut: $:.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: aTimestamp minutes).
	stream nextPut: $:.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: aTimestamp seconds).
	aBoolean ifFalse: [^self].
	Dialect supportsMillisecondsInTimes ifFalse: [ ^self ].
	ms := aTimestamp milliseconds.
	ms = 0 ifTrue: [^self].
	stream nextPut: $..
	stream nextPutAll: (GlorpDatabaseType padToThreeDigits: ms).	
	stream nextPut: $".

]

{ #category : 'conversion - times' }
UDBCSQLite3Platform >> printTimestamp: aTimestampString on: stream for: aType [

	aTimestampString isNil ifTrue: [stream nextPutAll: 'NULL'. ^self].
	stream nextPut: $'.
	aTimestampString printOn: stream.
	stream nextPut: $'.
]

{ #category : 'conversion - times' }
UDBCSQLite3Platform >> readDate: anObject for: aType [
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class == Date ifTrue: [^anObject].
	anObject isString ifTrue: [
		^self readDateFromStream: (ReadStream on: anObject) for: aType].
	^anObject asDate.
]

{ #category : 'conversion - times' }
UDBCSQLite3Platform >> readTime: anObject for: aType [
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class == Time ifTrue: [^anObject].
	anObject isString ifTrue: [
		^self readTimeFromStream: (ReadStream on: anObject) for: aType].
	^anObject asTime.
]

{ #category : 'conversion - times' }
UDBCSQLite3Platform >> readTimestamp: anObject for: aType [
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class == Dialect timestampClass ifTrue: [^anObject].
	anObject isString
		ifTrue:
			[| stream |
			stream := ReadStream on: anObject.
			^self readTimestampFromStream: stream for: aType].
	^anObject asDateAndTime.
]

{ #category : 'testing' }
UDBCSQLite3Platform >> supportsArithmeticOperatorsOnDates [
	^ false
]

{ #category : 'testing' }
UDBCSQLite3Platform >> supportsBinding [
	^ true
]

{ #category : 'testing' }
UDBCSQLite3Platform >> supportsMillisecondsInTimes [
	^ true
]

{ #category : 'testing' }
UDBCSQLite3Platform >> supportsRowCount [
	^ true
]

{ #category : 'conversion - times' }
UDBCSQLite3Platform >> toDate: anObject for: aType [
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class = Date ifTrue: [^anObject].
	anObject isInteger ifTrue: [^anObject].
	^anObject asDate
]

{ #category : 'conversion - times' }
UDBCSQLite3Platform >> toTime: anObject for: aType [
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class = Time ifTrue: [^anObject].
	^anObject asTime.
]

{ #category : 'conversion - times' }
UDBCSQLite3Platform >> toTimestamp: anObject for: aType [
	"From DatabasePlatform."

	anObject isNil ifTrue: [^nil].
	anObject class = Dialect timestampClass ifTrue: [^anObject].
	anObject isInteger ifTrue: [^anObject].
	^anObject asDateAndTime
]

{ #category : 'constants' }
UDBCSQLite3Platform >> usesNullForEmptyStrings [
	^ false
]
