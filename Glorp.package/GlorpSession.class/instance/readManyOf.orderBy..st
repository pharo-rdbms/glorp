api/queries
readManyOf: aClass orderBy: aCriteria
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:orderBy: instead'.
	^self read: aClass orderBy: aCriteria