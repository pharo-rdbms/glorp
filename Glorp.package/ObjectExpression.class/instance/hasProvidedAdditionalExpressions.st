testing
hasProvidedAdditionalExpressions
	"Return true if we have already provided additional expressions to some query. Only important when we're preparing a subselect and don't want to bring in joins that are part of the main query"
	^self hasTableAliases.