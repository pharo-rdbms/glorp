printing
printPrimaryKeyTemplateOn: aStream
	"If there is no primary key (i.e. this is a link table) use all the values that we have"
	| fields |
	fields := table primaryKeyFields isEmpty 
		ifTrue: [self fields]
		ifFalse: [table primaryKeyFields].
	GlorpHelper
		do:  [:eachField |
			self printEqualityTemplateForField: eachField on: aStream]
		for: fields
		separatedBy: [aStream nextPutAll: ' AND '].