misc
lookupObject: aNumber ofClass: aClass ifAbsentPut: absentBlock

	^(objects at: aClass ifAbsentPut: [Dictionary new]) at: aNumber ifAbsentPut: absentBlock.