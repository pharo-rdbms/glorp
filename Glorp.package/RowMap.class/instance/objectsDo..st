iterating
objectsDo: aBlock
	self tables
		do:
			[:each | 
			(self subMapForTable: each)
				keysAndValuesDo:
					[:key :value | (self isDeleted: value) ifFalse: [aBlock value: key]]]