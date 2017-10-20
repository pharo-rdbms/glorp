initialize-release
withAllSuperclassesDo: aBlock
	| currentClass |
	currentClass := self class.
	[currentClass == Object]
		whileFalse:
			[aBlock value: currentClass.
			currentClass := currentClass superclass]