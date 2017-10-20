support
helpTestBasicAliasing: aTable
	self deny: exp hasTableAliases.
	exp assignTableAliasesStartingAt: 1 prefix: 's1t'.
	self assert: exp hasTableAliases.
	self assert: exp tableAliases size = 1.
	self assert: (exp tableAliases at: aTable) name = 's1t1'.