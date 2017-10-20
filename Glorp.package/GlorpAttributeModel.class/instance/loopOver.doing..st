mapping
loopOver: mightBeACollection doing: aBlock
	"It is possible that the value for a dictionary attribute is nil. If so, do not map it back"
	| index |
	self isCollectionAttribute ifFalse: [self checkTargetType: mightBeACollection. ^aBlock value: 1 value: mightBeACollection].
	mightBeACollection isNil ifTrue: [^nil].
	self isDictionaryAttribute ifTrue: [^mightBeACollection keysAndValuesDo: [:key :value |
		self checkTargetTypeForKey: key value: value. 
		value ifNotNil: [aBlock value: key value: value]]].
	index := 1.
	mightBeACollection glorpIsCollection ifFalse: [
		(GlorpInvalidTypeError new object: mightBeACollection; expectedType: self collectionType) signal].
	mightBeACollection
		do:
			[:each |
			| object | 
			object := each glorpRealObject. 
			self checkTargetType: object.
			aBlock value: index value: object.
			index := index + 1]