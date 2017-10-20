private
convertedDbValueOf: stValue 
	"Mappings in general don't know how to do type conversion. Subclasses that deal with database primitive types should override."
	^stValue