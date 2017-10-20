SQL
print: aValue on: aStream
	"Print as though we were a regular time field, since our Smalltalk object has no time zone information."

	self platform time print: aValue on: aStream.