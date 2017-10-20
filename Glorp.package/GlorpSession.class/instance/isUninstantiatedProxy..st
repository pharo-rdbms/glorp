testing
isUninstantiatedProxy: anObject
	^anObject isGlorpProxy and: [anObject isInstantiated not]