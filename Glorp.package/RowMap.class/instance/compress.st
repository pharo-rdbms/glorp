private/deletion
compress
	"Remove all deleted rows and rebuild"
	| newDictionary |
	hasDeletions ifFalse: [^self].
	hasDeletions := false.
	newDictionary := IdentityDictionary new: rowDictionary size.
	rowDictionary keysAndValuesDo: [:eachTable :eachRowDict |
		| newRowDict |
		newRowDict := IdentityDictionary new: eachRowDict size.
		eachRowDict keysAndValuesDo: [:eachObject :eachRow |
			(self isDeleted: eachRow) ifFalse: [
				newRowDict at: eachObject put: eachRow]].
		newDictionary at: eachTable put: newRowDict].
	rowDictionary := newDictionary.