iterating
objects
	| objects |
	objects := IdentitySet new.
	self tables do: [:each | objects addAll: (self subMapForTable: each) keys].
	^objects