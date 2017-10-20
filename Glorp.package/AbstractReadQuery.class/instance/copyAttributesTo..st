copying
copyAttributesTo: newQuery
	"We're creating a new query similar to ourselves, but not a direct copy. Copy over the relevant attributes."

	super copyAttributesTo: newQuery.
	newQuery limit: self limit.
	newQuery offset: self offset.
	newQuery proxyType: self proxyType.
	newQuery shouldRefresh: self shouldRefresh