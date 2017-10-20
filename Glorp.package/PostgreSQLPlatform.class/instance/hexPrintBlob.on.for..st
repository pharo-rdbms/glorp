conversion-strings
hexPrintBlob: aByteArray on: aStream for: aType

	aStream nextPutAll: 'E'''.
	aStream nextPutAll: '\\x'.
	aStream nextPutAll: aByteArray hex.
	aStream nextPutAll: '''::bytea'.