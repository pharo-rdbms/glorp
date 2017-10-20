accessing
= anObject
	"In VA we inherit this as identity. Need to override"
	^self isGlorpProxy & anObject isGlorpProxy
		ifTrue: [ self getValue = anObject getValue ]
		ifFalse: [ super = anObject ]