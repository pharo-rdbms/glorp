lookup
expireKey: key ifAbsent: aBlock
	| item |
	item := self basicAt: key ifAbsent: [^aBlock value].
	policy expire: item.