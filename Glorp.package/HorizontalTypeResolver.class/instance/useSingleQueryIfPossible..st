accessing
useSingleQueryIfPossible: aBoolean
	"Use single query if the platform allows it. Otherwise, don't."

	shouldUseSingleQuery := aBoolean and: [self supportsUsingSingleQuery]