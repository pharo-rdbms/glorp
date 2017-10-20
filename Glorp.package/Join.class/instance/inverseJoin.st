converting
inverseJoin
	| inverse |
	inverse := self class new
		base: base;
		sourceFields: targets
		targetFields: sources.
	inverse owningMapping: self owningMapping.
	^inverse.