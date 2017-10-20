conversion-times
readTimeFromStream: aStream for: aType
	"Seems like we get to do this ourselves, in a lowest common denominator kind of way. Ignore timezones right now"
	"assumes ISO format.
	self readTimestamp: '2003-03-03 15:29:28.337-05' for: nil.
	self readTimestamp: '2003-03-03 19:29:28.337-05' for: nil

"
	| hours minutes seconds milliseconds timeZoneOffset millisecondAccumulator |
	hours := (aStream upTo: $:) asNumber.
	minutes := (aStream upTo: $:) asNumber.
	seconds := (aStream next: 2) asNumber.
	(aStream peek = $.) 
		ifTrue: [
			aStream next.
			millisecondAccumulator := WriteStream on: String new.
			[aStream atEnd not and: [aStream peek isDigit]] whileTrue: [
				millisecondAccumulator nextPut: aStream next].
			milliseconds := millisecondAccumulator contents asNumber]
		ifFalse: [milliseconds := 0].
	timeZoneOffset := aStream upToEnd.
	timeZoneOffset := Number readFrom: timeZoneOffset ifFail: [ 0 ].
	^Dialect newTimeWithHours: hours minutes: minutes seconds: seconds milliseconds: milliseconds.
	"^Dialect addSeconds: (timeZoneOffset * -1* 60 * 60) to: aTime."