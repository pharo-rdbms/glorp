SQL
print: aValue on: aStream
	aStream nextPutAll: (self platform printBoolean: aValue for: self).