proxy actions
glorpOwner
	"Return the object for which this proxy was created. Note that this is not kept track of unless we have a proxy action."
	action isNil ifTrue: [^nil].
	^action key.