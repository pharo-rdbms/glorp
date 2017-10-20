tests
testDirectQuery

	| items query item |
	self writeTestHarness.
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

	session reset.
	item := session readOneOf: GlorpPerishableItem
		where: [:each | each name = 'bicycle'].
	self assert: item isNil.
	item := session readOneOf: GlorpInventoryItem
		where: [:each | each name = 'something that does not exist'].
	self assert: item isNil.