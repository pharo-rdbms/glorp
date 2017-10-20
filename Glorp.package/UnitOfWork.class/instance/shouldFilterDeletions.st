testing
shouldFilterDeletions
	"Should we filter deleted objects from the results of queries. We don't do this if we're in the process of registering the transitive closure, because any fetches we do there are in order to get information we need for the commit (e.g. primary keys). If we filtered the deleted objects, then we may not be able to figure out primary keys for the objects to be deleted"
	^commitPhase ~~ #registering