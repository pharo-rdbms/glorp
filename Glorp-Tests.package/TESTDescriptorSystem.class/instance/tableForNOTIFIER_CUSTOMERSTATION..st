tables
tableForNOTIFIER_CUSTOMERSTATION: aTable

	(aTable createFieldNamed: 'STATION' type: platform number) bePrimaryKey.
	aTable addForeignKeyFromAll: ((OrderedCollection new)
				add: ((self tableNamed: 'NOTIFIER_CUSTOMERSTATION') fieldNamed: 'STATION');
				yourself)
		toAll: ((OrderedCollection new)
				add: ((self tableNamed: 'NOTIFIER_STATION') fieldNamed: 'ID');
				yourself)