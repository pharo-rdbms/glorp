copying
copyFrom: anAttributeModel
	"Copy over the attributes if it defines them and we don't"
	anAttributeModel isNil ifTrue: [^self].
	self type isNil ifTrue: [self type: anAttributeModel type].
	self collectionType isNil
		ifTrue: [self collectionType: anAttributeModel collectionType].
	self privateUseDirectAccess isNil
		ifTrue: [useDirectAccess := anAttributeModel privateUseDirectAccess].
	canRead := anAttributeModel canRead.
	canWrite := anAttributeModel canWrite.