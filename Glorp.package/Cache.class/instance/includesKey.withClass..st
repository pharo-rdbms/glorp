lookup
includesKey: key withClass: aClass
	"Return true if we include the object, and it matches our class. Don't listen to any expiry policy"
	| item value |
	item := self basicAt: key ifAbsent: [^false].
	value := policy contentsOf: item.
	^value isKindOf: aClass.