initialize-release
setConverterBetween: aClass and: aDbField 
	aClass isNil ifTrue: [^self].
	converter := descriptor ifNotNil: 
					[descriptor system converterBetweenStType: aClass andField: aDbField]
				ifNil: [aDbField converterForStType: aClass]