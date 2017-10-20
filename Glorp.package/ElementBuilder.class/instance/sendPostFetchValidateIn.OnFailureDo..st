building objects
sendPostFetchValidateIn: aSession OnFailureDo: aBlock
	| validateResult |
	validateResult := aSession sendPostFetchValidateEventTo: self instance.
	(self didValidationFail: validateResult) ifTrue: aBlock