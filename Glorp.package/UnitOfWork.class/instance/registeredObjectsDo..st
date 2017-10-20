enumerating
registeredObjectsDo: aBlock

	transaction registeredObjectsDo: [:each |
		(each glorpIsCollection or: [session hasDescriptorFor: each]) ifTrue: [
			aBlock value: each]]