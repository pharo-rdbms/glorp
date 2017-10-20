*Glorp
returningOneOf: aClass
	"Backward-compatibility, since we changed the class name."
	"returningOneOf: is a synonym of readOneOf:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #readOneOf: instead'.
	^self readOneOf: aClass.