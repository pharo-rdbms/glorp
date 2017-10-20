initialize-release
initialize: size
	rowDictionary := IdentityDictionary new: size.
	hasDeletions := false