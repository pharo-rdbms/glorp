tables
tableForNOTIFIER_FEEDERSTATION: aTable

	(aTable createFieldNamed: 'STATION' type: platform number) bePrimaryKey.
	aTable addForeignKeyFromAll: ((OrderedCollection new)
				add: ((self tableNamed: 'NOTIFIER_FEEDERSTATION') fieldNamed: 'STATION');
				yourself)
		toAll: ((OrderedCollection new)
				add: ((self tableNamed: 'NOTIFIER_STATION') fieldNamed: 'ID');
				yourself)