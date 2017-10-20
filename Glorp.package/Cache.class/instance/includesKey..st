lookup
includesKey: key
	"Return true if we include the object. Don't listen to any expiry policy"
	self basicAt: key ifAbsent: [^false].
	^true.