descriptors
descriptorForSuccessor: aDescriptor

	| table1 |
	table1 := self tableNamed: 'NOTIFIER_SUCCESSOR'.
	aDescriptor table: table1.
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #successorCustomer;
		join: (Join fromAll: ((OrderedCollection new)
							add: ((self tableNamed: 'NOTIFIER_SUCCESSOR') fieldNamed: 'NEXTCUSTOMER');
							yourself)
					toAll: ((OrderedCollection new)
							add: ((self tableNamed: 'NOTIFIER_CUSTOMERSTATION') fieldNamed: 'STATION');
							yourself));
		proxyAction: [:owner :value | value postFetchGlorp].
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #station;
		join: (Join fromAll: ((OrderedCollection new)
							add: ((self tableNamed: 'NOTIFIER_SUCCESSOR') fieldNamed: 'STATION');
							yourself)
					toAll: ((OrderedCollection new)
							add: ((self tableNamed: 'NOTIFIER_STATION') fieldNamed: 'ID');
							yourself));
		proxyAction: [:owner :value | value postFetchGlorp].
	(aDescriptor newMapping: DirectMapping)
		from: #id to: (table1 fieldNamed: 'ID');
		converter: ((PluggableDatabaseConverter new)
					name: '@yourself|yourself';
					dbToStConverter: [:aValue | aValue yourself];
					stToDbConverter: [:aValue | aValue yourself];
					yourself).
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #successorFeeder;
		join: (Join fromAll: ((OrderedCollection new)
							add: ((self tableNamed: 'NOTIFIER_SUCCESSOR') fieldNamed: 'NEXTFEEDER');
							yourself)
					toAll: ((OrderedCollection new)
							add: ((self tableNamed: 'NOTIFIER_FEEDERSTATION') fieldNamed: 'STATION');
							yourself));
		proxyAction: [:owner :value | value postFetchGlorp]