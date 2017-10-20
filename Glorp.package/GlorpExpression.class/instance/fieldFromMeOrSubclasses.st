accessing
fieldFromMeOrSubclasses
	"For mapping expression, return the field for this mapping, but if the field is not mapped, and the class uses inheritance, check for subclasses, and use a random one of the subclass mappings. For all others, just return the field."
	^self field.