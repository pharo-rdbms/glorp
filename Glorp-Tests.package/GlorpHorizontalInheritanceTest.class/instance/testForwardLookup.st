tests - tags
testForwardLookup
	| image |
	self writeTestHarnessForTags.
	image := session
				readOneOf: GlorpImage
				where: [:each | each location = 'testlocation'].
	self assert: image tags size = 2.
	self assert: (image tags contains: [:tag| tag key = 'first']).
	self assert: (image tags contains: [:tag| tag key = 'second']).