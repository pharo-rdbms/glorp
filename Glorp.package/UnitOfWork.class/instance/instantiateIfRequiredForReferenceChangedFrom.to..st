private/mapping
instantiateIfRequiredForReferenceChangedFrom: originalTarget to: newTarget
	"For an existing relationship, we need to instantiate if the object we're referring to changed, and either was or is now a proxy. Actually we might get away without if it used to be, but now isn't, but better safe than sorry."

	| wasProxy  |
	originalTarget == newTarget ifTrue: [^false].
	wasProxy := false.
	self notFilteringDeletesDo: [
		originalTarget isGlorpProxy ifTrue: [wasProxy := true. originalTarget getValue].
		newTarget isGlorpProxy ifTrue: [wasProxy := true. newTarget getValue]].
	^wasProxy