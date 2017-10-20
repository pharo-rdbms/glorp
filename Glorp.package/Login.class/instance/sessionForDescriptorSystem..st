session creation
sessionForDescriptorSystem: aDescriptorSystemClass
	"Create a session for this login, using aDescriptorSystemClass for its metadata"
	^aDescriptorSystemClass sessionForLogin: self.