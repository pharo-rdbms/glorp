testing
isForPseudoVariable
	"Return true if this is a pseudo-variable - one which is neither read nor written, and doesn't have a corresponding instance variable, but is only used for queries."
	^(canRead not & canWrite not) or: [self isValid not]