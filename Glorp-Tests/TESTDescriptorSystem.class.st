Class {
	#name : #TESTDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
TESTDescriptorSystem class >> queryForCustomerStation [
	| query |
	query := Query read: CustomerStation
				where: [:customerStation | customerStation successor anySatisfy: [:successor | successor in: self queryForSuccessor]].
	query retrieve: [:customerStation | customerStation id].
	^query
]

{ #category : #'as yet unclassified' }
TESTDescriptorSystem class >> queryForFeederStation [
	| query |
	query := Query read: FeederStation where: [:feederStation | feederStation id in: #(1 2 3 4)].
	query retrieve: [:feederStation | feederStation id].
	^query
]

{ #category : #'as yet unclassified' }
TESTDescriptorSystem class >> queryForSuccessor [
	| query |
	query := Query read: Successor where: [:successor | successor successorFeeder in: self queryForFeederStation].
	query retrieve: [:successor | successor id].
	^query
]

{ #category : #'as yet unclassified' }
TESTDescriptorSystem class >> testInnerQueries [
	"self testInnerQueries"

	| session system query result |
	session := GlorpSession new.
	system := self new.
	system platform: OraclePlatform new.
	session system: system.
	system session: session.
	query := self queryForCustomerStation.
	result := session execute: query.
	^result
]

{ #category : #'as yet unclassified' }
TESTDescriptorSystem class >> testLocalInnerQueries [
	"self testLocalInnerQueries"

	| session system query result |
	session := GlorpSession new.
	system := self new.
	system platform: OraclePlatform new.
	session system: system.
	system session: session.
	query := Query read: CustomerStation where: 
		[:customerStation |
		customerStation successor anySatisfy: 
			[:successor || query2 |
			query2 := Query read: Successor where: 
				[:successor1 || feederQuery |
				feederQuery := Query read: FeederStation where:
					[:feederStation | feederStation id in: #(1 2 3 4)].
				feederQuery retrieve: [:feederStation | feederStation id].
				successor1 successorFeeder in: feederQuery].
			query2 retrieve: [:successor1 | successor1 id].
			successor in: query2]].
	query retrieve: [:customerStation | customerStation id].
	result := session execute: query.
	^result
]

{ #category : #classes }
TESTDescriptorSystem >> classModelForCustomerStation: aClassModel [

	aClassModel newAttributeNamed: #id type: SmallInteger.
	aClassModel newAttributeNamed: #successor collection: Array of: Successor.
]

{ #category : #classes }
TESTDescriptorSystem >> classModelForFeederStation: aClassModel [

	aClassModel newAttributeNamed: #id type: SmallInteger.
	aClassModel newAttributeNamed: #successor collection: Array of: Successor.
]

{ #category : #classes }
TESTDescriptorSystem >> classModelForStation: aClassModel [

	aClassModel newAttributeNamed: #id type: SmallInteger.
	aClassModel newAttributeNamed: #successor collection: Array of: Successor
]

{ #category : #classes }
TESTDescriptorSystem >> classModelForSuccessor: aClassModel [

	aClassModel newAttributeNamed: #id type: SmallInteger.
	aClassModel newAttributeNamed: #successorCustomer type: CustomerStation.
	aClassModel newAttributeNamed: #successorFeeder type: FeederStation.
	aClassModel newAttributeNamed: #station type: Station
]

{ #category : #descriptors }
TESTDescriptorSystem >> descriptorForCustomerStation: aDescriptor [

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
]

{ #category : #descriptors }
TESTDescriptorSystem >> descriptorForFeederStation: aDescriptor [

	| table1 table2 |
	(self typeResolverFor: Station) register: aDescriptor.
	table1 := self tableNamed: 'NOTIFIER_STATION'.
	aDescriptor table: table1.
	table2 := self tableNamed: 'NOTIFIER_FEEDERSTATION'.
	aDescriptor table: table2.
	aDescriptor
		addMultipleTableJoin: (Join fromAll: ((OrderedCollection new)
						add: ((self tableNamed: 'NOTIFIER_FEEDERSTATION') fieldNamed: 'STATION');
						yourself)
				toAll: ((OrderedCollection new)
						add: ((self tableNamed: 'NOTIFIER_STATION') fieldNamed: 'ID');
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
]

{ #category : #descriptors }
TESTDescriptorSystem >> descriptorForStation: aDescriptor [

	| table1 |
	table1 := self tableNamed: 'NOTIFIER_STATION'.
	aDescriptor table: table1.
	(self typeResolverFor: Station) register: aDescriptor abstract: true.
]

{ #category : #descriptors }
TESTDescriptorSystem >> descriptorForSuccessor: aDescriptor [

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
]

{ #category : #tables }
TESTDescriptorSystem >> tableForNOTIFIER_CUSTOMERSTATION: aTable [

	(aTable createFieldNamed: 'STATION' type: platform number) bePrimaryKey.
	aTable addForeignKeyFromAll: ((OrderedCollection new)
				add: ((self tableNamed: 'NOTIFIER_CUSTOMERSTATION') fieldNamed: 'STATION');
				yourself)
		toAll: ((OrderedCollection new)
				add: ((self tableNamed: 'NOTIFIER_STATION') fieldNamed: 'ID');
				yourself)
]

{ #category : #tables }
TESTDescriptorSystem >> tableForNOTIFIER_FEEDERSTATION: aTable [

	(aTable createFieldNamed: 'STATION' type: platform number) bePrimaryKey.
	aTable addForeignKeyFromAll: ((OrderedCollection new)
				add: ((self tableNamed: 'NOTIFIER_FEEDERSTATION') fieldNamed: 'STATION');
				yourself)
		toAll: ((OrderedCollection new)
				add: ((self tableNamed: 'NOTIFIER_STATION') fieldNamed: 'ID');
				yourself)
]

{ #category : #tables }
TESTDescriptorSystem >> tableForNOTIFIER_STATION: aTable [

	(aTable
		createFieldNamed: 'ID'
		type: (platform number)) bePrimaryKey.
]

{ #category : #tables }
TESTDescriptorSystem >> tableForNOTIFIER_SUCCESSOR: aTable [

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
]

{ #category : #'type resolvers' }
TESTDescriptorSystem >> typeResolverForStation [

	^HorizontalTypeResolver forRootClass: Station
]
