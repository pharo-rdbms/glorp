accessing
typeMapping
	^mappings detect: [ :each | each isTypeMapping ] ifNone: [
		| mapping |
		mapping := IdentityTypeMapping new.
		self addMapping: mapping.
		mapping]