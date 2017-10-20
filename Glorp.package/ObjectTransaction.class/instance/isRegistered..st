registering
isRegistered: anObject 
	"Note: We can never have a situation where a proxy is registered but its contents aren't, so we don't have to worry about that ambiguous case."
	| realObject |
	realObject := self realObjectFor: anObject ifNone: [^false].
	^undoMap includesKey: realObject