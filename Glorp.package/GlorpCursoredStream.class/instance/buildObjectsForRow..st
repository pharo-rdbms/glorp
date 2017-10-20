building objects
buildObjectsForRow: aRow
	self query isNil ifTrue: [^aRow].
	builders
		do:
			[:each | each findInstanceForRow: aRow proxyType: self query proxyType].
	builders do: [:each | each buildObjectFrom: aRow].
	builders
		do:
			[:each | 
			each
				sendPostFetchValidateIn: self session 
				OnFailureDo: [each instance: nil]].
	builders
		do: [:each | each instance == nil ifFalse: [each knitResultIn: self]].
	builders do: [:each | self session sendPostFetchEventTo: each instance].
	^self buildersThatReturnResults size = 1
		ifTrue: [self buildersThatReturnResults first returnValueIn: self]
		ifFalse:
			[self buildersThatReturnResults collect: [:each | each returnValueIn: self]]