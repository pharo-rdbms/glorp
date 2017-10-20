iterating
objectsAndRowsDo: aTwoArgumentBlock
	rowDictionary
		do:
			[:eachObjectToRowDictionary | 
			eachObjectToRowDictionary
				keysAndValuesDo:
					[:key :value | 
					(self isDeleted: value)
						ifFalse: [aTwoArgumentBlock value: key value: value]]]