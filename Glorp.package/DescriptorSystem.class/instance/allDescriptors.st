accessing
allDescriptors

	^self allClasses collect: [:each | 
		self descriptorFor: each]