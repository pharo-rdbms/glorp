tables
tableForNOTIFIER_SUCCESSOR: aTable

	aTable
		createFieldNamed: 'NEXTCUSTOMER'
		type: (platform number).
	aTable
		createFieldNamed: 'STATION'
		type: (platform number).
	aTable
		createFieldNamed: 'NEXTFEEDER'
		type: (platform number).
	(aTable
		createFieldNamed: 'ID'
		type: (platform number)) bePrimaryKey.
	aTable
		addForeignKeyFromAll:
				((OrderedCollection new)
					add: ((self tableNamed: 'NOTIFIER_SUCCESSOR') fieldNamed: 'NEXTCUSTOMER');
					yourself)
			toAll:
				((OrderedCollection new)
					add: ((self tableNamed: 'NOTIFIER_CUSTOMERSTATION') fieldNamed: 'STATION');
					yourself).

	aTable
		addForeignKeyFromAll:
				((OrderedCollection new)
					add: ((self tableNamed: 'NOTIFIER_SUCCESSOR') fieldNamed: 'NEXTFEEDER');
					yourself)
			toAll:
				((OrderedCollection new)
					add: ((self tableNamed: 'NOTIFIER_FEEDERSTATION') fieldNamed: 'STATION');
					yourself).

	aTable
		addForeignKeyFromAll:
				((OrderedCollection new)
					add: ((self tableNamed: 'NOTIFIER_SUCCESSOR') fieldNamed: 'STATION');
					yourself)
			toAll:
				((OrderedCollection new)
					add: ((self tableNamed: 'NOTIFIER_STATION') fieldNamed: 'ID');
					yourself).