tests
helpTestPrintTimestamp: aTimestampString

	| aStream ts timestamp |
	ts := DatabasePlatform new readTimestamp: aTimestampString for: nil.
	aStream := WriteStream on: String new.
	DatabasePlatform new printDate: ts isoFormatOn: aStream.
	aStream nextPut: Character space.
	DatabasePlatform new printTime: ts isoFormatOn: aStream milliseconds: Dialect supportsMillisecondsInTimes .
	timestamp := aStream contents.
	self assert: timestamp = aTimestampString.