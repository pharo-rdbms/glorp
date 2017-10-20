SQL
print: aValue on: aStream
	"Print as though we were a regular timestamp field, since we have no time zone information."

	self platform timestamp print: aValue on: aStream.