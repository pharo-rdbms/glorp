building objects
didValidationFail: validateResult

	"In other words, don't treat the result of the validation send to the object as a failure if the object was the boolean false, so returning self would normally be interpreted as the failure"
	validateResult == self instance ifTrue: [^false].

	^super didValidationFail: validateResult