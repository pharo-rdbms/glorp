helpers
helpTestValue: anObject compareWith: aBlock 
	self 
		helpTestValue: anObject
		compareModelWith: [:read :original | true]
		compareWith: aBlock