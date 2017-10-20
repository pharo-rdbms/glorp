knitting
add: anObject to: aCollection in: ourObject
	"If this is an array we can't just add to it, we must concatenate and re-set the value"
	| newCollection |
	aCollection class == Array 
		ifTrue: [	
			newCollection := aCollection, (Array with: anObject).
			self setValueIn: ourObject to: newCollection.
			^self].
	(anObject class == Association and: [anObject key == nil])
		ifFalse: [aCollection add: anObject]