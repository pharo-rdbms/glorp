converting
impliedSmalltalkType
	self isIntegerType ifTrue: [^Integer].
	^super impliedSmalltalkType