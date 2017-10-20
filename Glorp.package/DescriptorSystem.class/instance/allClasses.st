accessing
allClasses
	allClasses isEmpty ifTrue: [allClasses := self constructAllClasses].
	^allClasses