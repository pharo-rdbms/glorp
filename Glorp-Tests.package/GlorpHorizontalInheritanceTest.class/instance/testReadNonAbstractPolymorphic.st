tests
testReadNonAbstractPolymorphic
	"This test excercises a problem that existed with MappingExpression caching its mapping
	and which was then copied to the newly created MappingExpressions for subclasses.
	This isn't a problem when reading from an abstract class since there are no mappings to cache."

	| wagon |
	
	self writeTestHarness.
	wagon := session readOneOf: GlorpNonperishableItem where: [:each | each name = 'wagon'].
	self should: [wagon serialNumber = 99958]