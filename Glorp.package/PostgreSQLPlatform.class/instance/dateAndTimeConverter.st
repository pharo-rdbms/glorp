as yet unclassified
dateAndTimeConverter

	^PluggableDatabaseConverter new
		dbToStConverter: [:dateAndTime | dateAndTime];
		stToDbConverter: [:dateAndTime | dateAndTime ifNotNil: [:c | dateAndTime printString ]];
		yourself