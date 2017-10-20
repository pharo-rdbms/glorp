registering
needsCollectionMementoFor: aCollection
	"We can avoid the need for a collection copy if the collection has no internal structure - that is, if we'll be able to loop over a simple shallow copy. This is dialect and collection class dependent"
	^Dialect needsCollectionMementoFor: aCollection