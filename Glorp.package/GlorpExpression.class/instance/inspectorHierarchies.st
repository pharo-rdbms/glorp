inspecting
inspectorHierarchies
	| hierarchy |
	hierarchy := ((Smalltalk at: #Tools ifAbsent: [^#()])
		at: #Trippy ifAbsent: [^#()])
		at: #Hierarchy ifAbsent: [^#()].
	^Array with: (hierarchy
			id: #expression
			label: 'Expression Tree'
			parentBlock: [:each | nil]
			childrenBlock: [:each | each inspectorChildren])