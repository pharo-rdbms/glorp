tests
testConstantInClassDoesNotWriteToRow

	"Would raise an exception if it tried to write into nil"
	mappingToClass mapFromObject: self intoRowsIn: nil.