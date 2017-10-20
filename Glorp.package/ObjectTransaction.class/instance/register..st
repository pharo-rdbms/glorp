registering
register: anObject 
	"Make anObject be a member of the current transaction. Return the object if registered, or nil otherwise"

	| copy realObject |
	(self requiresRegistrationFor: anObject) ifFalse: [^nil].
	realObject := self realObjectFor: anObject ifNone: [^nil].
	copy := self shallowCopyOf: realObject ifNotNeeded: [^nil].
	undoMap at: realObject put: copy.
	self registerTransientInternalsOfCollection: realObject.
	^realObject