private
markAsCurrentAtKey: key
	| item |
	item := self basicAt: key ifAbsent: [^false].
	^policy markEntryAsCurrent: item in: self.