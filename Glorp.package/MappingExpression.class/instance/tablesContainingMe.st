accessing
tablesContainingMe
	"Return a list of tables that contain this object, whether or not we control them. This is mostly the same as tables, but will differ for embedded mappings."
	| set |
	self descriptor isNil ifTrue: [^#()].
	set := self descriptor tables asSet.
	^set.