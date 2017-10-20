copying
copyAttributesTo: newQuery
	"We're creating a new query similar to ourselves, ut not a direct copy. Copy over the relevant attributes. Note that we don't copy over the ordering, because that's less universally appropriate. Caller beware."

	newQuery expectedRows: self expectedRows.
	newQuery collectionType: self collectionType.
	newQuery readsOneObject: self readsOneObject.
	newQuery maximumLobSizeToRetrieveDirectly: self maximumLobSizeToRetrieveDirectly