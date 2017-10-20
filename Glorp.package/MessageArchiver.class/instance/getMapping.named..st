expression protocol
getMapping: aMapping named: aString
	"In this case, the name may actually be a string rather than a symbol."
	^MessageArchiverForGetMapping
		receiver: self
		selector: aString
		arguments: (Array with: aMapping with: aString)