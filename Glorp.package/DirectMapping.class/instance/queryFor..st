mapping
queryFor: anObjectBuilder
	"If we have a specific query we should use in this case, rather than our general one, construct it. Right now that only applies if we're using filtered reads"
	^self query