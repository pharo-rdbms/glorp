printing
printSelectSQLOn: aStream withParameters: aDictionary 
	"Normally, we're not printable, but we might be if we're inverting a direct to-many mapping. In that case, there should only be one mapped field"
	self descriptor mappedFields do: [:each | (self translateField: each) printSQLOn: aStream withParameters: aDictionary].