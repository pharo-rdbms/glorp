proxy actions
glorpOwner: anObject
	"If we don't have an action, the owner is unnecessary. Ignore it. If we do have one, put it in as the key of an association with the action block following it."
	action isNil ifTrue: [^self].
	action key: anObject