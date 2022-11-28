Extension { #name : #Date }

{ #category : #'*Glorp' }
Date >> glorpPrintSQLOn: aCommand [
	"Print the date in ISO format. 'yyyy-mm-dd'  Don't rely on any dialect-specific formatting or padding mechanisms"
	| monthString dayString |
	aCommand 
		nextPut: $';
		print: self year;
		nextPut: $-.
	monthString := self monthIndex printString.
	monthString size = 1 ifTrue: [aCommand nextPut: $0 ].
	aCommand nextPutAll: monthString.
	aCommand nextPut: $-.
	dayString := self dayOfMonth printString.
	dayString size = 1 ifTrue: [aCommand nextPut: $0 ].
	aCommand nextPutAll: dayString.
	aCommand nextPut: $'.
]
