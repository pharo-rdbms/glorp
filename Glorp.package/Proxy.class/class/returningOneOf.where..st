*Glorp
returningOneOf: aClass where: aBlock
	"returningOneOf: is a synonyms of readOneOf:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #readOneOf:where: instead'.
	^self readOneOf: aClass where: aBlock