get/set
checkTargetType: anObject
	"Check that anObject's type corresponds to something we know how to handle for this attribute. We expect this to be a real object, not a collection."
	self checkTargetType: anObject against: self type