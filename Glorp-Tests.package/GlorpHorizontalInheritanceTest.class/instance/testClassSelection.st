tests
testClassSelection

	| classes |
	classes := (session system descriptorFor: GlorpInventoryItem) classesRequiringIndependentQueries collect: [:each | each name ].
	self assert: classes size = 3.
	#(#GlorpNonperishableItem #GlorpPerishableItem #GlorpUnassembledItem) do: [:name |
		self assert: (classes includes: name) ].

	classes := (session system descriptorFor: GlorpPerishableItem) classesRequiringIndependentQueries collect: [:each | each name ].
	self assert: classes size = 1.
	#(#GlorpPerishableItem) do: [:name |
		self assert: (classes includes: name) ].

	classes := (session system descriptorFor: GlorpNonperishableItem) classesRequiringIndependentQueries collect: [:each | each name ].
	self assert: classes size = 2.
	#(#GlorpNonperishableItem #GlorpUnassembledItem) do: [:name |
		self assert: (classes includes: name)].