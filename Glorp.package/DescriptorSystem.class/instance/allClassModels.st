accessing
allClassModels
	^self allClasses collect: [:each | 
		self classModelFor: each]