api
linkFields: aCollection
	"Set the fields that are foreign keys *from* the link table (this is only used if we have one) to the *target* table. This is used as a hint in the case where the link table is ambiguous, and is easier than specifying the full join."
	linkFields := aCollection.