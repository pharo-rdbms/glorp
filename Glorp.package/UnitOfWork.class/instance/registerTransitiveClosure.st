begin/commit/abort
registerTransitiveClosure
	"Look for new objects reachable from currently registered objects, and propagate deletions"

	self computeCollectionDeletes.
	self
		registeredObjectsDo:
			[:eachObject | self registerTransitiveClosureFrom: eachObject].
	self propagateDeletes.