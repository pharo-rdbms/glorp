testing
requiresWrapperQuery
	^self requiresDistinct
		or: [self hasOrdering
			or: [self hasGrouping]]