Class {
	#name : #GlorpEncyclopediaStockDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models - Encyclopedia'
}

{ #category : #accessing }
GlorpEncyclopediaStockDescriptorSystem >> allTableNames [

	^ #( 'GR_TINY_PUBLISHER' 'PU2B_TITLES_STOCK' )
]

{ #category : #descriptors }
GlorpEncyclopediaStockDescriptorSystem >> classModelForGlorpTinyPublisher: aClassModel [

	aClassModel
		newAttributeNamed: #id;
	 	newAttributeNamed: #name;
	 	newAttributeNamed: #titles collection: Array of: String;
	  	newAttributeNamed: #titlesWithNumberInStock dictionaryFrom: String to: Integer
]

{ #category : #initialization }
GlorpEncyclopediaStockDescriptorSystem >> constructAllClasses [

	^(super constructAllClasses)
		add: GlorpTinyPublisher;
		yourself
]

{ #category : #descriptors }
GlorpEncyclopediaStockDescriptorSystem >> descriptorForGlorpTinyPublisher: aDescriptor [

	| table titleStockTable |
	table := self tableNamed: 'GR_TINY_PUBLISHER'.

	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #name
		to: (table fieldNamed: 'NAME').

	titleStockTable := self tableNamed: 'PU2B_TITLES_STOCK'.
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #titlesWithNumberInStock;
		usesLinkTable: false;
		keyField: (titleStockTable fieldNamed: 'TITLE');
		valueField: (titleStockTable fieldNamed: 'STOCK');
		join: (Join
				 from: (table fieldNamed: 'ID')
				 to: (titleStockTable fieldNamed: 'TINY_PUBLISHER_ID'))
]

{ #category : #examples }
GlorpEncyclopediaStockDescriptorSystem >> examplePublisher1 [
	"Put in the copies to avoid an issue with reverting immutable objects."

	^ GlorpTinyPublisher new
		  id: 1;
		  name: 'Cambridge';
		  titles: (Array
				   with: 'Mastering ENVY/Developer' copy
				   with: 'Principia Mathematica' copy
				   with: 'Metadata-Based Persistence for Dummies' copy);
		  titlesWithNumberInStock: (Dictionary new
				   at: 'Mastering ENVY/Developer' put: 2;
				   at: 'Principia Mathematica' put: 2;
				   at: 'Metadata-Based Persistence for Dummies' put: 2;
				   yourself)
]

{ #category : #examples }
GlorpEncyclopediaStockDescriptorSystem >> examplePublisher2 [

	^ GlorpTinyPublisher new
		  id: 2;
		  name: 'Harper Collins';
		  titles: (Array with: 'A book' copy);
		  titlesWithNumberInStock: (Dictionary new
				   at: 'A book' copy put: 200;
				   yourself)
]

{ #category : #examples }
GlorpEncyclopediaStockDescriptorSystem >> examplePublishers [

	^ Array with: self examplePublisher1 with: self examplePublisher2
]

{ #category : #tables }
GlorpEncyclopediaStockDescriptorSystem >> tableForGR_TINY_PUBLISHER: aTable [

	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 50)
]

{ #category : #tables }
GlorpEncyclopediaStockDescriptorSystem >> tableForPU2B_TITLES_STOCK: aTable [
	"Use a different table name to avoid conflicts with GlorpEncyclopediaDescriptorSystem."

	| pubId |
	pubId := (aTable
		          createFieldNamed: 'TINY_PUBLISHER_ID'
		          type: platform int4)
		         bePrimaryKey;
		         yourself.
	aTable
		addForeignKeyFrom: pubId
		to: ((self tableNamed: 'GR_TINY_PUBLISHER') fieldNamed: 'ID').
	(aTable createFieldNamed: 'TITLE' type: (platform varChar: 50))
		bePrimaryKey.
	aTable createFieldNamed: 'STOCK' type: platform int4.
	aTable createFieldNamed: 'UNUSED' type: (platform varchar: 10)
]
