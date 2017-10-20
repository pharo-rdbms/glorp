mapping
buildRowMapKeyForSource: source target: target index: index
	^self mapsSimpleObject 
		ifTrue: [
			MultipleRowMapKey
				with: target yourSelf
				with: source yourSelf
				with: index]
		ifFalse: [super buildRowMapKeyForSource: source target: target index: index]