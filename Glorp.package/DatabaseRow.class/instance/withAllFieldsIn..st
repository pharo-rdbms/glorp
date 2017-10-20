configuring
withAllFieldsIn: aRow 
	"aRow represents our original state. Make sure that we have all the fields in aRow, using nil values for any that are missing. This is needed if, e.g. we have been removed from a 1-many relationship, so we don't get a value generated for our foreign key, but we should still write it as a nil. We have to distinguish this from the case of a value that simply hasn't changed."

	aRow isEmpty ifTrue: [^self].
	oldVersion := aRow.
	self numberOfFields = table fields size ifTrue: [^self].
	aRow fieldsAndValidValuesDo: 
			[:eachField :eachValue | 
			(self includesField: eachField) ifFalse: [self at: eachField put: nil]].
	^self