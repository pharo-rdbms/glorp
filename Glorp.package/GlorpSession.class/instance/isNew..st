testing
isNew: anObject 
	"When registering, do we need to add this object to the collection of new objects? New objects are treated specially when computing what needs to be written, since we don't have their previous state"

	| key descriptor |
	(currentUnitOfWork notNil and: [currentUnitOfWork isRegistered: anObject]) ifTrue: [^false].
	descriptor := self descriptorFor: anObject.
	descriptor isNil ifTrue: [^false].
	"For embedded values we assume that they are not new. This appears to work. I can't really justify it."
	self needsWork: 'cross your fingers'.
	descriptor mapsPrimaryKeys ifFalse: [^false].

	key := descriptor primaryKeyFor: anObject.
	key isNil ifTrue: [^true].
	"If the cache contains the object, but the existing entry is due to be deleted, then count this entry as a new one being added with the same primary key (ick) as the old one"
	^[(self cacheContainsObject: anObject key: key) not]
		on: DuplicatePrimaryKeyException
		do: [:ex |
			(currentUnitOfWork notNil and: [currentUnitOfWork willDelete: ex existingObject]) 
				ifTrue: [
					self cacheRemoveObject: ex existingObject.
					ex return: true]
				ifFalse: [ex pass]].