adding
at: aKey insert: anObject

	| subCache |
	subCache := self cacheForClass: anObject class.
	subCache at: aKey ifAbsentPut: [anObject].