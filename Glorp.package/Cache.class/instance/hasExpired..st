lookup
hasExpired: key
	| item |
	item := self basicAt: key ifAbsent: [^false].
	^self hasItemExpired: item.