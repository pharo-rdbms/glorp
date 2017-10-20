api
getValue

	self isInstantiated ifTrue: [^value].
	[value := readBlock value] ensure: [isInstantiated := true].
	^value