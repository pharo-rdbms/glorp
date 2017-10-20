initialize/release
initializeAttribute
	"This is where we can initialize aspects of the attribute, if required. The motivating example is initializing the collection type of the attribute if it wasn't set. We need it to have some type, but we don't want to initialize it while we're doing basic initialization and aren't yet properly attached to a descriptor or class model"