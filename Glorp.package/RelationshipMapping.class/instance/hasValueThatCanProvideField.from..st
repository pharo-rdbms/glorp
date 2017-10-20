testing
hasValueThatCanProvideField: aField from: anObject
	"Return true if we have enough information in ourselves to populate our fields. The only time this won't be true is if we're either holding an uninstantiated proxy or have a to-many relationship mapping with an empty collection. Assumes that aField is one that we map."
	| value |
	value := self getValueFrom: anObject.
	value isGlorpProxy ifFalse: [^value notNil].
	value isInstantiated ifTrue: [^true].
	^value parameters includesKey: aField.