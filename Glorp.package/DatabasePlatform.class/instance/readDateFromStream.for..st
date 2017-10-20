conversion-times
readDateFromStream: aStream for: aType
	"Seems like we get to do this ourselves, in a lowest common denominator kind of way. Translate into GMT if we've got a timezone."
	"assumes ISO format.
	self readTimestamp: '2003-03-03 15:29:28.337-05' for: nil.
	self readTimestamp: '2003-03-03 19:29:28.337-05' for: nil

"
	|  years months days |
	years := (aStream upTo: $-) asNumber.
	months := (aStream upTo: $-) asNumber.
	days := (aStream upTo: $ ) asNumber.
	^Dialect newDateWithYears: years months: months days: days.