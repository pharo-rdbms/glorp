executing
readFromDatabaseWithParameters: anArray

	| subQueries |
	subQueries := self descriptor classesRequiringIndependentQueries collect: 
					[:eachClass |
					self shouldUseSingleQuery
						ifTrue: [self asQueryWithNullsForOtherClasses: eachClass]
						ifFalse: 
							[(self asSimpleQueryFor: eachClass)
								setupTracing;
								assignTableAliases;
								yourself]].
	^self executeSubQueries: subQueries withParameters: anArray