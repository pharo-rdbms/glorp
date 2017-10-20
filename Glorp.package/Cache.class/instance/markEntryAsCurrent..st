private
markEntryAsCurrent: anItem
	"The policy has told us to mark an item as current. This is only really useful for weak policies, which tell us to keep an additional pointer to the object in a (presumably) fixed-size collection"
	extraReferences isNil ifFalse: [extraReferences add: anItem].