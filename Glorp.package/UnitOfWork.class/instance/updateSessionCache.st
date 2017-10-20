private/mapping
updateSessionCache
	rowMap
		keysAndValuesDo: [:eachObject :eachRow | 
			eachRow shouldBeWritten ifTrue: [
				self updateSessionCacheFor: eachObject withRow: eachRow]].
	deletedObjects do: [:each |
		session cacheRemoveObject: each].
	linkRowsForUpdate do: [:eachRow |
		eachRow shouldBeWritten ifTrue: [
			self updateSessionCacheFor: eachRow owner withRow: eachRow]].