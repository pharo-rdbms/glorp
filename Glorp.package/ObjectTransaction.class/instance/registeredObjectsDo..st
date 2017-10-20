registering
registeredObjectsDo: aBlock
	"Iterate over all our objects. Note that this will include objects without descriptors. Be sure we're iterating over a copy of the keys, because this will add objects to the undoMap. Allow the block to return a collection which we will then add to the list of things to process, until there's nothing further"

	| newAdditions previousVersion |
	newAdditions := undoMap keys.
	previousVersion := newAdditions.
	[newAdditions isEmpty]
		whileFalse:
			[newAdditions do: aBlock.
			newAdditions := OrderedCollection new.
			undoMap
				keysDo:
					[:eachKey | (previousVersion includes: eachKey) ifFalse: [newAdditions add: eachKey]].
			newAdditions isEmpty ifFalse: [previousVersion := undoMap keys]]