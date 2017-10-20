building objects
instanceExistsButIsDeleted
	instance isNil ifTrue: [^false].
	instance := self session filterDeletionFrom: instance.
	^instance isNil.