api/queries
readManyOf: aClass where: aBlock limit: anInteger
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where:limit: instead'.
	^self read: aClass where: aBlock limit: anInteger