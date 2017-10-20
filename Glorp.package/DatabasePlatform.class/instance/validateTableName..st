services tables
validateTableName: tableNameString
	" <Boolean> I return true, if the choosen tableNameString is valid for the platform"

 	^( tableNameString size <= self maximumLengthOfTableName ) 
			and: [ (self predefinedKeywords includes: tableNameString asLowercase) not ]