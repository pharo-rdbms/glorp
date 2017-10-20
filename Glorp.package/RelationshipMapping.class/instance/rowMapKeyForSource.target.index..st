mapping
rowMapKeyForSource: source target: target index: index
	"Create the row map key. Make sure we're holding onto the real objects, so proxies don't time out on us"

	self needsSpecialRowMapKey ifFalse: [^target].
	(target yourSelf isNil or: [source yourSelf isNil]) ifTrue: [^nil].
	^rowMapKeyConstructorBlock isNil
		ifTrue:
			[self
				buildRowMapKeyForSource: source
				target: target
				index: index]
		ifFalse:
			[rowMapKeyConstructorBlock value: source yourSelf value: target yourSelf].