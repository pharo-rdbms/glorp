adjusting
adjustIn: aCorrespondenceMap
	"Adjust ourselves to refer to the copies rather than the originals"
	| adjusted |
	adjusted := self copy.
	adjusted key1: (aCorrespondenceMap at: key1 ifAbsent: [key1]).
	adjusted key2: (aCorrespondenceMap at: key2 ifAbsent: [key2]).
	^adjusted