iterating
loopOverAttributeOf: anObject doing: aTwoArgumentBlock
	"Loop over the target, which we extract from anObject, and iterate over it evaluating the block. For things that aren't collections, iterating means just run once. Note that the argument is expected to be an instance of our descriptor, as opposed to the attribute method, which expects the target object"
	| target |
	target := self getValueFrom: anObject.
	self attribute loopOver: target doing: aTwoArgumentBlock