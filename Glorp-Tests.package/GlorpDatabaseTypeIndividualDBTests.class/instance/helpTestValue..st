helpers
helpTestValue: anObject 
	"Don't try and read back an equal float, it'll likely fail on precision issues"

	self 
		helpTestValue: anObject
		compareModelWith: 
			[:read :original | 
			read notNil and: 
					[(original isKindOf: Float) or: 
							[original class == Dialect doublePrecisionFloatClass 
								or: [read test = original]]]]
		compareWith: [:read :original | read = original]