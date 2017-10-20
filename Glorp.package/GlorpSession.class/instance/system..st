api
system: aDescriptorSystem
	"Why the on:do:? Because when loading over an old version, the method 
	#validateDescriptorSystem may not yet be in the system, so we send it carefully"

	aDescriptorSystem session: self.
	accessor isNil ifFalse: [aDescriptorSystem platform: accessor currentLogin database].
	system := aDescriptorSystem.
	([system validateDescriptorSystem]
		on: Error
		do: [:exception | exception return: true])
			ifTrue: [system validate]
			ifFalse: [system initializeRuntimeMappings]