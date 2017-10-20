accessing
allTargetFields
	^joins inject: OrderedCollection new into: [:sum :each | sum addAll: each allTargetFields. sum]