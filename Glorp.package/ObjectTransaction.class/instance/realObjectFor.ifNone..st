registering
realObjectFor: anObject ifNone: aBlock
	"If this is a proxy, return the contents (if available). Otherwise, evaluate the block"
	^anObject isGlorpProxy 
		ifTrue: [anObject isInstantiated ifTrue: [anObject getValue] ifFalse: [aBlock value]]
		ifFalse: [anObject]