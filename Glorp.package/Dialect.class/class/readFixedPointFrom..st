dates
readFixedPointFrom: aString

	^ Number readFrom: (ReadStream on: aString , 's')