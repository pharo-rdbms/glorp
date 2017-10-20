tests
testReadRelationship
	| warehouse |
	
	self writeTestHarness.
	warehouse := session readOneOf: GlorpWarehouse
				where: [:each | each address = '123 Some Ave.'].
	self assert: warehouse address = '123 Some Ave.'.
	self assert: warehouse currentItem name = 'squash'.
	self assert: (warehouse items collect: [:each | each name]) asSortedCollection asArray = #('apples' 'bicycle' 'fridge').