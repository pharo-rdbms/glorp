creating mappings
newMapping: aClass
	| mapping |
	mapping := aClass new.
	self basicAddMapping: mapping.
	^mapping