descriptors
descriptorForCustomerStation: aDescriptor

	| table1 table2 |
	(self typeResolverFor: Station) register: aDescriptor.
	table1 := self tableNamed: 'NOTIFIER_STATION'.
	aDescriptor table: table1.
	table2 := self tableNamed: 'NOTIFIER_CUSTOMERSTATION'.
	aDescriptor table: table2.
	aDescriptor
		addMultipleTableJoin: (Join fromAll: ((OrderedCollection new)
						add: ((self tableNamed: 'NOTIFIER_STATION') fieldNamed: 'ID');
						yourself)
				toAll: ((OrderedCollection new)
						add: ((self tableNamed: 'NOTIFIER_CUSTOMERSTATION') fieldNamed: 'STATION');
						yourself)).
	(aDescriptor newMapping: ToManyMapping)
		attributeName: #successor;
		join: (Join fromAll: ((OrderedCollection new)
							add: ((self tableNamed: 'NOTIFIER_STATION') fieldNamed: 'ID');
							yourself)
					toAll: ((OrderedCollection new)
							add: ((self tableNamed: 'NOTIFIER_SUCCESSOR') fieldNamed: 'STATION');
							yourself));
		proxyAction: [:owner :value | value postFetchGlorp].
	(aDescriptor newMapping: DirectMapping)
		from: #id to: (table1 fieldNamed: 'ID');
		converter: ((PluggableDatabaseConverter new)
					name: '@yourself|yourself';
					dbToStConverter: [:aValue | aValue yourself];
					stToDbConverter: [:aValue | aValue yourself];
					yourself)