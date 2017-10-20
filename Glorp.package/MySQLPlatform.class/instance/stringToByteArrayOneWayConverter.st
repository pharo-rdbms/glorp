conversion-strings
stringToByteArrayOneWayConverter
	"This is a special converter for MySQL that is a null conversion on the way out, but converts the byte arrays that we get back from blobs into strings."
	^DelegatingDatabaseConverter
		named: #stringToByteArrayOneWay
		hostedBy: self
		fromStToDb: #nullConversion:for:
		fromDbToSt: #byteArrayToString:for:.