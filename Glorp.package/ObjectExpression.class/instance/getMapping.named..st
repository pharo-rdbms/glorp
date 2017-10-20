api
getMapping: aMapping named: aString
	"Get a mapping expression given the actual mapping (this is most useful for an anonymous mapping that isn't named or in our descriptor). Only if you really know what you're doing!. Short circuit looking up the mapping, checking for functions, and so on."

	^self mappingExpressions at: aString
		ifAbsentPut: [ | expression |
			expression := MappingExpression named: aString basedOn: self.
			expression mapping: aMapping.
			expression].