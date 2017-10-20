types
versionFieldFor: aType
	"Don't cache this, because we want to return different instances depending on aType"
	^(VersionType underlyingType: aType) generatesOverExistingValues: true; platform: self.