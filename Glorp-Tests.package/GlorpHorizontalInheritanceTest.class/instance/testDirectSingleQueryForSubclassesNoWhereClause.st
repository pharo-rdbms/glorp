tests
testDirectSingleQueryForSubclassesNoWhereClause

	| items query normalResult filtered |
	self writeTestHarness.
	(session system descriptorFor: GlorpInventoryItem) typeResolver useSingleQueryIfPossible: true.
	query := Query read: GlorpInventoryItem.
	items := session execute: query.
	self assert: items size = 7.
	GlorpInventoryItem allSubclasses do: [:each |
		normalResult := session read: each.
		filtered := items select: [:other | other isKindOf: each].
		self assert: normalResult size = filtered size].