SQL
print: aValue on: aStream
	self platform printBlob: (aValue isNil ifTrue: [nil] ifFalse: [aValue asByteArray]) on: aStream for: self.