deletion
computeCollectionDeletes
	"If we have objects that are part of exclusive collections, and they have been removed from those collections, then they must be deleted. Note that we do this *before* we register the transitive closure at the end of the unit of work. That means we won't know about any new objects yet, but we don't care because new objects won't be deleted in this way. And that way if we delete and then add another object with (ick) the same primary key, we shouldn't have a clash because the delete will already have been issued."

	self registeredObjects do: [:each |
		| descriptor |
		(descriptor := session descriptorFor: each class) isNil
			ifFalse: [descriptor mappings do: [:eachMapping |
				self computeCollectionDeletesFor: eachMapping inObject: each]]].