setup
setUp
	
	super setUp.
	login := GlorpDatabaseLoginResource current.
	self class needsSetup ifFalse: [^self].
	login accessor doDDLOperation:
			[GlorpTestDescriptorSystem allSubclasses
				do: [:eachSystemClass | 
					self setUpSystem: (eachSystemClass forPlatform: login platform) setUpDefaults].
			self populateStuffTable].