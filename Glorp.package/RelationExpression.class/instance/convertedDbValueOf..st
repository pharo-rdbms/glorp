As yet unclassified
convertedDbValueOf: anObject
	"Assume that our types match, so we can ask either child to do the conversion. That isn't guaranteed, but should at least work for the common cases."
	^leftChild convertedDbValueOf: anObject.