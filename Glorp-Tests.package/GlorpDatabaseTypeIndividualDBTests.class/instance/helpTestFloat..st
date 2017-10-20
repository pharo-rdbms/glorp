helpers
helpTestFloat: anObject
	"Don't try and read back an equal float, it'll likely fail on precision issues"

	self
		helpTestValue: anObject
		compareModelWith:
			[:read :original | self compareFloatInModel: read with: original]
		compareWith:
			[:read :original | original isNil or: [(read - original) abs <= 0.00001]].