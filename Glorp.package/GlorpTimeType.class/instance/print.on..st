SQL
print: aValue on: aStream
	aStream nextPutAll: (self platform printTime: aValue for: self).