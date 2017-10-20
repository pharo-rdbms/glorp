accessing
underlyingType: aDatabaseType
	underlyingType := aDatabaseType.
	platform := aDatabaseType platform.
	generator := self generatorFor: aDatabaseType.