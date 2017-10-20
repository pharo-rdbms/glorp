accessing
titlesWithNumberInStock: aDictionary
	titlesWithNumberInStock := aDictionary.
	self titlesWithNumberInStockLink: (Dictionary new addAll: (aDictionary associations collect: [:each | each copy]); yourself).