accessing
convertedDbValueOf: anObject
	"Not clear what should happen here, but let's just pass it through for the moment"
	^(self converterForStType: anObject class) convert: anObject toDatabaseRepresentationAs: self type.