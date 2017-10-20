adjusting
adjustIn: aCorrespondenceMap
	"Adjust ourselves to refer to the copies rather than the originals"
	| adjusted |
	adjusted := self copy.
	adjusted keys: (keys collect: [:each | aCorrespondenceMap at: each ifAbsent: [each]]).
	^adjusted