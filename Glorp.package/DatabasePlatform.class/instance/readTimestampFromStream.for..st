conversion-times
readTimestampFromStream: aStream for: aType

	| years months days hours minutes seconds millisecondAccumulator milliseconds timeZoneOffset |
	years := (aStream upTo: $-) asNumber.
	months := (aStream upTo: $-) asNumber.
	days := (aStream upTo: $ ) asNumber.
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
	timeZoneOffset := Number readFrom: aStream upToEnd ifFail: [ 0 ].
	timeZoneOffset := timeZoneOffset * 60 * 60.
	^Dialect 
		newTimestampWithYears: years
		months: months
		days: days
		hours: hours
		minutes: minutes
		seconds: seconds
		milliseconds: milliseconds
		offset:timeZoneOffset.