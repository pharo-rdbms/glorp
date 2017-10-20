adjusting
reverseAdjustIn: aRowMapForMementos
	"Adjust ourselves to refer to the copies rather than the originals"
	| adjusted |
	adjusted := self copy.
	adjusted key1: (aRowMapForMementos reversedCorrespondenceMap at: key1 ifAbsent: [key1]).
	adjusted key2: (aRowMapForMementos reversedCorrespondenceMap at: key2 ifAbsent: [key2]).
	^adjusted