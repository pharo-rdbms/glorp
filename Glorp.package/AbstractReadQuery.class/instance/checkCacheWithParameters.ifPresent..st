caching
checkCacheWithParameters: aDictionary ifPresent: aBlock
	| primaryKey result filteredResult |
	readsOneObject ifFalse: [^nil].
	self shouldRefresh ifTrue: [^nil].
	"Check if we have retrieval expressions for something other than the base. If so, we're not actually reading this object, or at least not just this object"
	self tracing retrievalExpressions do: [:each | each base isNil ifFalse: [^self]].
	primaryKey := self primaryKeyFrom: aDictionary.
	"We can't figure out the primary key"
	primaryKey isNil ifTrue: [^nil].
	"The primary key is invalid (i.e. has nulls in it). So we've found the entry, and we know it's nil"
	primaryKey = #() ifTrue: [^aBlock value: nil].
	"If it's expired, make sure we do the read but still refresh"
  	(session hasExpired: resultClass key: primaryKey) ifTrue: [
		self shouldRefresh: true.
		^nil].
	result := session 
		cacheAt: primaryKey
		forClass: resultClass
		ifNone: [nil].
	filteredResult := session filterDeletionFrom: result.
	^filteredResult isNil ifTrue: [nil] ifFalse: [
		(session system shouldResetExpiryTimeForObjectOfClass: filteredResult class readFrom: self)
			ifTrue: [self session markAsCurrentOfClass: filteredResult class key: primaryKey].
		aBlock value: filteredResult]