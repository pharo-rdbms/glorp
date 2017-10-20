accessing
encoding: aSymbol
	"The platform is a Glorp databasePlatform, so its setter code is generic across all dialects.  The connection is specific to the dialect;  some dialects will need to override how its encoding is set.  In the hope that most dialects will find this works for them, and that coders porting to dialects in which it does not will benefit from seeing the walkback and knowing they have something to do, we attempt to set both at top level."

	self platform characterEncoding: aSymbol.
	connection encoding: aSymbol.