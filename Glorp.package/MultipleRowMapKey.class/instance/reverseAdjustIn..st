adjusting
reverseAdjustIn: aRowMapForMementos
	"Adjust ourselves to refer to the originals rather than the copies"
	| adjusted |
	adjusted := self copy.
	adjusted keys: (keys collect: [:each | 
		aRowMapForMementos reversedCorrespondenceMap at: each ifAbsent: [each]]).
	^adjusted