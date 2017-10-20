tests
testDo

	| all |
	all := OrderedCollection new.
	vc do: [:each |
		self assert: (each isKindOf: GlorpPerson).
		all add: each.
		].
	self assert: all size = 3.
	self assert: all asSet size = 3.
	self assert: (all collect: [:each | each id]) asSortedCollection asArray = #(86 87 88).