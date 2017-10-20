copying
postCopy
	super postCopy.
	fields := OrderedCollection new.
	joins := OrderedCollection new.
	builders := nil.
	tablesToPrint := nil.