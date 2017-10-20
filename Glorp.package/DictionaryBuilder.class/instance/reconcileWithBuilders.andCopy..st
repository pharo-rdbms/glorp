copying
reconcileWithBuilders: oldCollection andCopy: newCollection
	"Fix up references to our internal sub-builders"
	| keyIndex valueIndex |
	keyIndex := oldCollection indexOf: keyBuilder.
	keyBuilder := newCollection at: keyIndex.
	valueIndex := oldCollection indexOf: valueBuilder.
	valueBuilder := newCollection at: valueIndex