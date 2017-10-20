mapping
applicableMappingForObject: anObject
	"We can actually be called here with our parent object, but the contexts in which that happens we basically just want to do nothing, so return our conditional mapping."
	[self attribute checkTargetType: anObject] on: GlorpInvalidTypeError do: [:ex | ^self conditional].
	^self conditional applicableMappingForObject: anObject