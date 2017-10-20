tests
testDirectSingleQueryForSubclasses

	| items query |
	self writeTestHarness.
	(session system descriptorFor: GlorpInventoryItem) typeResolver useSingleQueryIfPossible: true.
	query := Query read: GlorpInventoryItem
				where: [:each | each name = 'TV'].
	items := session execute: query.
	self assert: items size = 1.
	self assert: (items select: [:emp | emp isMemberOf: GlorpNonperishableItem]) size = 1.

	session reset.
	items := session read: GlorpInventoryItem
				where: [:each | each name = 'bicycle'].
	self assert: items size = 1.
	self assert: (items select: [:emp | emp isMemberOf: GlorpUnassembledItem]) size = 1.

	session reset.
	items := session read: GlorpPerishableItem
				where: [:each | each name = 'bicycle'].
	self assert: items size = 0.