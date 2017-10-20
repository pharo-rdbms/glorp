accessing
attributeName: anAttributeName referenceClass: aClass
	"In addition to setting the attribute, use that information to further configure our faked-up descriptor. We can pass in a reference class here, although this is only really useful if we don't already have an explicit classModel."
	| model |
	super attributeName: anAttributeName.
	aClass isNil ifFalse: [attribute type: aClass].
	model := GlorpClassModel for: super referenceClass.
	"We add a mapping for our value. We don't normally use this, because we expect people to refer directly to the attribute, but it means, for example, that the field shows up in our mapped fields without us having to fake it up. And you could write a query referring to anAttribute myValue if you wanted"
	model newAttributeNamed: #myValue type: self attribute type.
	self referenceDescriptor classModel: model