validation
initializeRuntimeMappings
	"Do any setups we need to make sure that my mappings are initialized for runtime"

	self mappings do: [:eachMapping | eachMapping initializeRuntimeMappings]