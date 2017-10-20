accessing
descriptorsRequiringIndependentQueriesFor: aClass
	"A FilteredTypeResolver holds all its subclasses' data in a single table, so should never require independent queries;  thus the only descriptor is that for aClass, and this should never need to be called.
	It is possible that some fields in the table are only meaningful for some subclasses, and so are only defined in the descriptors of some subclasses.  If a query using the field is made (presumably by mistake) for a class without the mapping, #mappingFromMeOrSubclasses will call this method in a (vain) attempt to find defined for FilteredTypeResolver, thence return nil and so enable #mappingFromMeOrSubclasses to fall through to the normal error processing (as its last comment says).
	Therefore we define this method, although expecting it will only ever be called en route to an error."

	^members select: [:each | each describedClass = aClass]