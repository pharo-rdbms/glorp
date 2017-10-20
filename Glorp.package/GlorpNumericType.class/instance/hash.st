comparing
hash
	"A very special case here, if we're effectively an Integer, then we need to hash in a way compatible with GlorpIntegerType"
	self isIntegerType ifTrue: [^self platform hash bitXor: self impliedSmalltalkType hash].
	^(super hash bitXor: self precision hash) bitXor: self scale hash