api
notEmpty
	"Only useful for mappings that represent collections. This checks to see if the collection has elements by building a not exists subselect."
	
	^self base existenceCheck: self as: #exists: