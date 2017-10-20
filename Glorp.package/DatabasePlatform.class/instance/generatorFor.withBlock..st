types
generatorFor: aType withBlock: aBlock
	"Don't cache this, because we want to return different instances depending on aType"
	^VersionType underlyingType: aType generator: (AdHocVersionGenerator block: aBlock).