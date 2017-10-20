lookup
includesKey: key as: anObject
	"Return true if we include the object, and it matches the given object. If we include a different object with the same key, raise an exception. Don't listen to any expiry policy"
	| item value |
	item := self basicAt: key ifAbsent: [^false].
	value := policy contentsOf: item.
	value == anObject ifFalse: [
		(DuplicatePrimaryKeyException new: anObject existing: value) signal].
	^true.