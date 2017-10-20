mapping
populateObject: anObject inBuilder: anElementBuilder
	"Answer an object using the values for the specified fields."

	mappings
		do: [:each | 
			each stopIfDebuggingRead.
			each mapObject: anObject inElementBuilder: anElementBuilder]