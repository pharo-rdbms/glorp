Extension { #name : 'Time' }

{ #category : '*Glorp' }
Time >> glorpPadToTwoDigits: anInteger [
	| string |
	string := anInteger truncated printString.
	^string size = 1 ifTrue: ['0', string] ifFalse: [string].
]

{ #category : '*Glorp' }
Time >> glorpPrintSQLOn: aCommand [
	"Print as 24 hour time"

	aCommand 
		nextPut: $';
		nextPutAll: 	(self glorpPadToTwoDigits: self hours);
		nextPut: $:;
		nextPutAll: (self glorpPadToTwoDigits: self minutes);
		nextPut: $:;
		nextPutAll: (self glorpPadToTwoDigits: self seconds);
		nextPut: $'.
]

{ #category : '*Glorp' }
Time >> millisecond: anInteger [ 

	nanos := (anInteger rem: 1000) * 1000000

]

{ #category : '*Glorp' }
Time >> milliseconds [
	^ (nanos / 1000000.0)truncated 
]
