tests - tags
testReverseLookup
	| image |
	self writeTestHarnessForTags.
	image := session
				readOneOf: GlorpImage
				where: [:each | each tags anySatisfy: [:tag| tag key = 'third']].
	self assert: image tags size = 2.
	self assert: (image tags contains: [:tag| tag key = 'first'])not.
	self assert: (image tags contains: [:tag| tag key = 'second']).