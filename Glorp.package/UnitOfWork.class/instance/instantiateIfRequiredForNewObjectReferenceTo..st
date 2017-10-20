private/mapping
instantiateIfRequiredForNewObjectReferenceTo: targetObject
	"If it's a new object, then we always need to instantiate"
	targetObject isGlorpProxy ifFalse: [^false].
	targetObject getValue.
	^true