descriptors
classModelForGlorpEncyclopedia: aClassModel 
 
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name. 
	aClassModel newAttributeNamed: #entries dictionaryFrom: String to: GlorpEncyclopediaEntry.
	"A slightly contrived way of having a mapping to a type of entries that don't use a link table."
	aClassModel newAttributeNamed: #biographicalEntries dictionaryFrom: String to: GlorpEncyclopediaBioEntry.