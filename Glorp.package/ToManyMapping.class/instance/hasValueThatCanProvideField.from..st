testing
hasValueThatCanProvideField: aField from: anObject
	"Return true if we have enough information in ourselves to populate our fields. The only time this won't be true is if we're either holding an uninstantiated proxy or have a to-many relationship mapping with an empty collection. Inline the superclass implementation to avoid fetching the value twice."
	| value |
	(super hasValueThatCanProvideField: aField from: anObject) ifFalse: [^false].
	value := self getValueFrom: anObject.
	^value isEmpty not