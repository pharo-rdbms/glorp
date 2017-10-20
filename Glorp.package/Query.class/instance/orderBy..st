ordering
orderBy: aBlock
	ordering isNil 
		ifTrue: [ordering := Array with: aBlock]
		ifFalse: [ordering := ordering , (Array with: aBlock)]