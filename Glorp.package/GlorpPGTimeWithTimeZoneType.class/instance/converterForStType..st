converting-times
converterForStType: aClass
	"Convert as though we were a regular time field, since our Smalltalk object has no time zone information."

	^self platform converterNamed: #time.