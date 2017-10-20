copying
postCopy

	super postCopy.
	queries := queries collect: [:each | each copy].