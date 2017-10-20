doesNotUnderstand
= anObject
	"Needed because VA's abtObservableWrapper implements =. Should be portable."
	^MessageArchiver 
		receiver: self
		selector: #= 
		arguments: (Array with: anObject)