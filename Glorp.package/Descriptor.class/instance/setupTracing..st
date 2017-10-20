tracing
setupTracing: aTracing
	"Find all the other objects that need to be read when this one is read"

	self trace: aTracing context: aTracing base