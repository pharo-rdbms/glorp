"
This is a set of test descriptors for dealing with different variations of dictionary mappings.
"
Class {
	#name : #GlorpEncyclopediaDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models - Encyclopedia'
}

{ #category : #other }
GlorpEncyclopediaDescriptorSystem >> allTableNames [
	^#('ENCYC' 'ENCYC_ENTRY' 'ENCYC_ENTRY_LINK' 'IMAGINARY_MEDIA_TYPE' 'GR_PUBLISHER' 'PUBLISHER_TITLE' 'PUB_TITLES_STOCK' 'PUB_TITLE_LINK' 'PUBLISHER_TITLE2' 'PUB_EMP_LINK' 'PUBLISHER_EMP').
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> classModelForGlorpEncyclopedia: aClassModel [ 
 
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name. 
	aClassModel newAttributeNamed: #entries dictionaryFrom: String to: GlorpEncyclopediaEntry.
	"A slightly contrived way of having a mapping to a type of entries that don't use a link table."
	aClassModel newAttributeNamed: #biographicalEntries dictionaryFrom: String to: GlorpEncyclopediaBioEntry.
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> classModelForGlorpEncyclopediaBioEntry: aClassModel [ 
	aClassModel newAttributeNamed: #owner type: GlorpEncyclopedia.
	aClassModel newAttributeNamed: #title.
	aClassModel newAttributeNamed: #text.
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> classModelForGlorpEncyclopediaEntry: aClassModel [ 
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #title.
	aClassModel newAttributeNamed: #text.
	aClassModel newAttributeNamed: #mediaType type: GlorpMediaType
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> classModelForGlorpMediaType: aClassModel [ 
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #mimeType
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> classModelForGlorpPublisher: aClassModel [ 
 
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name. 
	aClassModel newAttributeNamed: #titles collection: Array of: String.
	aClassModel newAttributeNamed: #titlesWithNumberInStock dictionaryFrom: String to: Integer.
	aClassModel newAttributeNamed: #employees dictionaryFrom: String to: GlorpPublisherEmployee.
	aClassModel newAttributeNamed: #differentBunchOfEmployeesById dictionaryFrom: Integer to: GlorpPublisherEmployee.

"	aClassModel newAttributeNamed: #titlesWithNumberInStockLink collection: Dictionary of: Integer."
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> classModelForGlorpPublisherEmployee: aClassModel [ 
 
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name. 
	aClassModel newAttributeNamed: #position.
]

{ #category : #other }
GlorpEncyclopediaDescriptorSystem >> constructAllClasses [
	^(super constructAllClasses)
		add: GlorpEncyclopedia;
		add: GlorpMediaType;
		add: GlorpEncyclopediaEntry;
		add: GlorpPublisher;
		add: GlorpPublisherEmployee;
		yourself
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> descriptorForGlorpEncyclopedia: aDescriptor [ 
	| table linkTable |
	table := self tableNamed: 'ENCYC'.
	linkTable := self tableNamed: 'ENCYC_ENTRY_LINK'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: BasicDictionaryMapping)
		attributeName: #entries;
		referenceClass: GlorpEncyclopediaEntry;
		keyField: (linkTable fieldNamed: 'REFERENCE_NO');
		linkFields: (Array 
					with: (linkTable fieldNamed: 'ENCYC_ENTRY_ID')).
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #biographicalEntries;
		referenceClass: GlorpEncyclopediaBioEntry;
		usesLinkTable: false;
		beExclusive;
		keyField: ((self tableNamed: 'ENCYC_BIO') fieldNamed: 'TITLE').
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> descriptorForGlorpEncyclopediaBioEntry: aDescriptor [ 
	| entryTable |
	entryTable := self tableNamed: 'ENCYC_BIO'.
	aDescriptor table: entryTable.
	"It's important that we have a mapping for the owner here, because we're expecting these entries to be deleted, and we can't delete them without knowing the primary keys."
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #owner;
		beReadOnly.
	(aDescriptor newMapping: DirectMapping) from: #title
		to: (entryTable fieldNamed: 'TITLE').
	(aDescriptor newMapping: DirectMapping) from: #text
		to: (entryTable fieldNamed: 'ENTRY_TEXT').
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> descriptorForGlorpEncyclopediaEntry: aDescriptor [ 
	| entryTable |
	entryTable := self tableNamed: 'ENCYC_ENTRY'.
	aDescriptor table: entryTable.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (entryTable fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #title
		to: (entryTable fieldNamed: 'TITLE').
	(aDescriptor newMapping: DirectMapping) from: #text
		to: (entryTable fieldNamed: 'ENTRY_TEXT').
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
		attributeName: #mediaType;
		referenceClass: GlorpMediaType;
		fieldTranslation: ((Join new)
					addSource: (entryTable fieldNamed: 'MEDIA_TYPE_NAME')
						target: ((self tableNamed: 'IMAGINARY_MEDIA_TYPE') 
								fieldNamed: 'MEDIA_TYPE_NAME');
					addSource: (entryTable fieldNamed: 'MEDIA_TYPE_MIME')
						target: ((self tableNamed: 'IMAGINARY_MEDIA_TYPE') 
								fieldNamed: 'MEDIA_TYPE_MIME');
					yourself).
	^aDescriptor
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> descriptorForGlorpMediaType: aDescriptor [ 
	| table |
	table := self tableNamed: 'IMAGINARY_MEDIA_TYPE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'MEDIA_TYPE_NAME').
	(aDescriptor newMapping: DirectMapping) from: #mimeType
		to: (table fieldNamed: 'MEDIA_TYPE_MIME')
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> descriptorForGlorpPublisher: aDescriptor [ 
	| table titleTable titleStockTable linkTable |
	table := self tableNamed: 'GR_PUBLISHER'.
	titleTable := self tableNamed: 'PUBLISHER_TITLE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectToManyMapping)
		attributeName: #titles;
		resultField: (titleTable fieldNamed: 'TITLE');
		writeTheOrderField;
		orderBy: [:each | (each getTable: titleTable) getField: 'POSITION'];
		join: (Join from: (table fieldNamed: 'ID') to: (titleTable fieldNamed: 'PUBLISHER_ID')).
	titleStockTable := self tableNamed: 'PUB_TITLES_STOCK'.
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #titlesWithNumberInStock;
		usesLinkTable: false;
		keyField: (titleStockTable fieldNamed: 'TITLE');
		valueField: (titleStockTable fieldNamed: 'STOCK');
		join: (Join from: (table fieldNamed: 'ID') to: (titleStockTable fieldNamed: 'PUBLISHER_ID')).
	linkTable := self tableNamed: 'PUB_EMP_LINK'.
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #employees;
		usesLinkTable: true;
		keyField: ((self tableNamed: 'PUBLISHER_EMP' ) fieldNamed: 'JOBTITLE');
		join: (Join 
			from: (table fieldNamed: 'ID')
			to: (linkTable fieldNamed: 'PUBLISHER_ID')
			from: 'A'
			to: (linkTable fieldNamed: 'FOO')).
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #differentBunchOfEmployeesById;
		usesLinkTable: true;
		join: (Join 
			from: (table fieldNamed: 'ID')
			to: (linkTable fieldNamed: 'PUBLISHER_ID')
			from: 'B'
			to: (linkTable fieldNamed: 'FOO'));
		keyField: ((self tableNamed: 'PUB_EMP_LINK') fieldNamed: 'EMP_ID').
		
"	titleStockLinkTable := self tableNamed: 'PUB_TITLE_LINK'.
	titleTable2 := self tableNamed: 'PUBLISHER_TITLE2'.
	(aDescriptor newMapping: DictionaryMapping)
		attributeName: #titlesWithNumberInStockLink;
		usesLinkTable: true;
		keyField: (titleTable2 fieldNamed: 'TITLE');
		valueField: (titleStockLinkTable fieldNamed: 'STOCK');
		linkTableJoin: (Join from: (table fieldNamed: 'ID') to: (titleStockLinkTable fieldNamed: 'PUBLISHER_ID'))."
]

{ #category : #descriptors }
GlorpEncyclopediaDescriptorSystem >> descriptorForGlorpPublisherEmployee: aDescriptor [ 
	| table |
	table := self tableNamed: 'PUBLISHER_EMP'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping) from: #jobTitle
		to: (table fieldNamed: 'JOBTITLE').
]

{ #category : #examples }
GlorpEncyclopediaDescriptorSystem >> exampleEncyclopedias [
	"self new exampleEncyclopedias"
	| encyc1 entry1 entry2 entry3 encyc2 encyc3 |
	encyc1 := GlorpEncyclopedia new id: 3; name: 'The Canadian Encyclopedia'.
	entry1 := self exampleEntry1.
	entry2 := self exampleEntry2.
	entry3 := self exampleEntry3.
	encyc1 articleAt: '12345' put: entry1.
	encyc1 articleAt: 'abcde' put: entry2.
	encyc1 articleAt: 'unique' put: entry3.
	encyc2 := GlorpEncyclopedia new id: 4; name: 'The Plagiarists Compendium'.
	encyc2 articleAt: '54321' put: entry1.
	encyc2 articleAt: 'edcba' put: entry2.
	encyc3 := GlorpEncyclopedia new id: 5; name: 'The Very Frugal Dictionary'.
	^Array with: encyc1 with: encyc2 with: encyc3.
]

{ #category : #examples }
GlorpEncyclopediaDescriptorSystem >> exampleEntry1 [
	^GlorpEncyclopediaEntry new 
		id: 'one';
		title: 'All About Ants';
		text: 'Ants are, like, these little tiny creatures. Gross.'.
]

{ #category : #examples }
GlorpEncyclopediaDescriptorSystem >> exampleEntry2 [
	^GlorpEncyclopediaEntry new 
		id: 'two';
		title: 'Computer Programming Languages';
		text: 'There are many different computer programming languages. The best one is Smalltalk.'.
]

{ #category : #examples }
GlorpEncyclopediaDescriptorSystem >> exampleEntry3 [
	^GlorpEncyclopediaEntry new 
		id: 'three';
		title: 'Vehicular Fish Decay';
		text: 'Do you know what happens if you leave a fish too long in an elevator? Well heres a clue. Fish is biodegradable. That means it rots.'.
]

{ #category : #examples }
GlorpEncyclopediaDescriptorSystem >> examplePublisher1 [
	"Put in the copies to avoid an issue with reverting immutable objects."
	^GlorpPublisher new 
		id: 1;
		name: 'Cambridge';
		titles: (Array with: 'Mastering ENVY/Developer' copy with: 'Principia Mathematica' copy with:  'Metadata-Based Persistence for Dummies' copy);
		titlesWithNumberInStock: (Dictionary new
			at:  'Mastering ENVY/Developer' put: 2;
			at: 'Principia Mathematica' put: 2;
			at: 'Metadata-Based Persistence for Dummies' put: 2;
			yourself);
		employees: (Dictionary new
			at: 'CEO' put: (GlorpPublisherEmployee new id: 1; name: 'The Boss'; jobTitle: 'CEO');
			at: 'Editor' put: (GlorpPublisherEmployee new id: 2; name: 'Somebody'; jobTitle: 'Editor');
			yourself);
		differentBunchOfEmployeesById: (Dictionary new
			at: 3 put: (GlorpPublisherEmployee new id: 3; name: 'Contractor 1'; jobTitle: 'Contractor');
			at: 4 put: (GlorpPublisherEmployee new id: 4; name: 'Contractor 2'; jobTitle: 'Contractor');
			yourself);
		yourself.
]

{ #category : #examples }
GlorpEncyclopediaDescriptorSystem >> examplePublisher2 [
	^GlorpPublisher new 
		id: 2;
		name: 'Harper Collins';
		titles: (Array with: 'A book' copy);
		titlesWithNumberInStock: (Dictionary new
			at:  'A book' copy put: 200;
			yourself).
]

{ #category : #examples }
GlorpEncyclopediaDescriptorSystem >> examplePublisher3 [
	^GlorpPublisher new 
		id: 3;
		name: 'A New Publishing company';
		titles: #().
]

{ #category : #examples }
GlorpEncyclopediaDescriptorSystem >> examplePublishers [
	^Array with: self examplePublisher1 with: self examplePublisher2 with: self examplePublisher3.
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForENCYC: aTable [ 

	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 50).
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForENCYC_BIO: aTable [ 

	| encycId |
	(aTable createFieldNamed: 'TITLE' type: (platform varChar: 50)) bePrimaryKey.
	encycId := aTable createFieldNamed: 'ENCYC_ID' type: platform integer.
	encycId bePrimaryKey.
	aTable addForeignKeyFrom: encycId to: ((self tableNamed: 'ENCYC') fieldNamed: 'ID').
	aTable createFieldNamed: 'ENTRY_TEXT' type: (platform varChar: 50).
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForENCYC_ENTRY: aTable [ 

	(aTable createFieldNamed: 'ID' type: (platform varChar: 50)) bePrimaryKey.
	aTable createFieldNamed: 'TITLE' type: (platform varChar: 50).
	aTable createFieldNamed: 'ENTRY_TEXT' type: (platform varChar: 200).
	aTable createFieldNamed: 'MEDIA_TYPE_NAME' type: (platform varChar: 100).
	aTable createFieldNamed: 'MEDIA_TYPE_MIME' type: (platform varChar: 100).
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForENCYC_ENTRY_LINK: aTable [ 

	| encycId entryId |
	encycId := aTable createFieldNamed: 'ENCYC_ID' type: platform int4.
	encycId bePrimaryKey.
	aTable addForeignKeyFrom: encycId to: ((self tableNamed: 'ENCYC') fieldNamed: 'ID').

	entryId := aTable createFieldNamed: 'ENCYC_ENTRY_ID' type: (platform varChar: 50).
	aTable addForeignKeyFrom: entryId to: ((self tableNamed: 'ENCYC_ENTRY') fieldNamed: 'ID').
	(aTable createFieldNamed: 'REFERENCE_NO' type: (platform varChar: 10)) bePrimaryKey.
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForGR_PUBLISHER: aTable [ 

	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 50).
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForIMAGINARY_MEDIA_TYPE: aTable [ 
	aTable isImaginary: true.
  
	aTable createFieldNamed: 'MEDIA_TYPE_NAME' type: (platform varChar: 100).
	aTable createFieldNamed: 'MEDIA_TYPE_MIME' type: (platform varChar: 100).
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForPUBLISHER_EMP: aTable [ 

	| |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 50).	
	aTable createFieldNamed: 'JOBTITLE' type: (platform varChar: 50).
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForPUBLISHER_TITLE2: aTable [ 

	| |
	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'TITLE' type: (platform varChar: 50).
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForPUBLISHER_TITLE: aTable [ 

	| pubId |
	pubId := aTable createFieldNamed: 'PUBLISHER_ID' type: platform int4.
	aTable addForeignKeyFrom: pubId  to: ((self tableNamed: 'GR_PUBLISHER') fieldNamed: 'ID').
	aTable createFieldNamed: 'POSITION' type: (platform int4).	
	aTable createFieldNamed: 'TITLE' type: (platform varChar: 50).
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForPUB_EMP_LINK: aTable [ 

	| pubId titleId |
	pubId := aTable createFieldNamed: 'PUBLISHER_ID' type: platform int4.
	aTable addForeignKeyFrom: pubId  to: ((self tableNamed: 'GR_PUBLISHER') fieldNamed: 'ID').
	titleId := aTable createFieldNamed: 'EMP_ID' type: platform int4.
	aTable addForeignKeyFrom: titleId  to: ((self tableNamed: 'PUBLISHER_EMP') fieldNamed: 'ID').
	aTable createFieldNamed: 'FOO' type: (platform varchar: 5).
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForPUB_TITLES_STOCK: aTable [ 

	| pubId |
	pubId := aTable createFieldNamed: 'PUBLISHER_ID' type: platform int4.
	aTable addForeignKeyFrom: pubId  to: ((self tableNamed: 'GR_PUBLISHER') fieldNamed: 'ID').
	aTable createFieldNamed: 'TITLE' type: (platform varChar: 50).
	aTable createFieldNamed: 'STOCK' type: platform int4.
]

{ #category : #tables }
GlorpEncyclopediaDescriptorSystem >> tableForPUB_TITLE_LINK: aTable [ 

	| pubId titleId |
	pubId := aTable createFieldNamed: 'PUBLISHER_ID' type: platform int4.
	aTable addForeignKeyFrom: pubId  to: ((self tableNamed: 'GR_PUBLISHER') fieldNamed: 'ID').
	titleId := aTable createFieldNamed: 'TITLE_ID' type: platform int4.
	aTable addForeignKeyFrom: titleId  to: ((self tableNamed: 'PUBLISHER_TITLE2') fieldNamed: 'ID').
	aTable createFieldNamed: 'STOCK' type: platform int4.
]
