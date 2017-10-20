as yet unclassified
print: aValue on: aStream

	aValue isNil
		ifTrue: [ aStream nextPutAll: 'NULL' ]
		ifFalse:[
			aValue printOn: aStream ].
