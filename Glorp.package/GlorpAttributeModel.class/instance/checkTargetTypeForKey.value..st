get/set
checkTargetTypeForKey: aKey value: anObject
	"Check that anObject's type corresponds to something we know how to handle for this attribute. We expect this to be a real object, not a collection. This is the version used for checking a dictionary, where we check both key and value, but only if they correspond to mapped classes."
	(self system classModelFor: self keyType) isNil 
		ifFalse: [self checkTargetType: aKey against: self keyType].
	(self system classModelFor: self type) isNil
		ifFalse: [self checkTargetType: anObject against: type]