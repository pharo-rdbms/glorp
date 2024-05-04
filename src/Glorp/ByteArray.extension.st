Extension { #name : 'ByteArray' }

{ #category : '*Glorp' }
ByteArray >> glorpIsCollection [
	"For our purposes, these aren't collections, but rather a simple database type"
	^false.
]

{ #category : '*Glorp' }
ByteArray >> glorpPrintSQLOn: aCommand [
	|aStream|
	aStream := WriteStream on: String new.
	aStream nextPutAll: 'E'''.
	self do: [:each |
		aStream nextPutAll: '\\'.
		aStream nextPutAll: (each asInteger printPaddedWith: $0 to: 3 base: 8 )].
	aStream nextPutAll: '''::bytea'.
	aCommand nextPutAll: aStream contents

]
