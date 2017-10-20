initialize-release
copyAttributeAttributes
	"We have an attributemodel that was created before we actually had a descriptor. It's possible that it had properties set. Make sure we copy them. If necessary, initialize things that require it."
	| oldAttribute |
	oldAttribute := attribute.
	attribute := self classModel attributeNamed: oldAttribute name type: oldAttribute type collectionType: oldAttribute collectionType.
	attribute copyFrom: oldAttribute.
	self initializeAttribute