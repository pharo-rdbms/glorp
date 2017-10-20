accessing
additionalExpressions
	| expressions |
	expressions := OrderedCollection new.
	self descriptor typeMapping addTypeMappingCriteriaTo: expressions in: self.
	expressions addAll: self multipleTableExpressions.
	^expressions