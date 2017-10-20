comparing
= aType
	(aType class == self platform numeric class and: [aType isIntegerType]) ifTrue: [^true].
	^super = aType