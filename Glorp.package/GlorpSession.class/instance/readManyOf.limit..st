api/queries
readManyOf: aClass limit: anInteger
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read: instead'.
	^self read: aClass limit: anInteger