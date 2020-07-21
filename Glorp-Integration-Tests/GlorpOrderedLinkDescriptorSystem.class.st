Class {
	#name : #GlorpOrderedLinkDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Integration-Tests-Models'
}

{ #category : #accessing }
GlorpOrderedLinkDescriptorSystem >> allTableNames [
	"Return a list of all the table names that this system uses."

	^#('FOLDERS' 'FOLDER_FILES_LINK' 'UNORDERED_LINK' 'FILES')
]

{ #category : #classes }
GlorpOrderedLinkDescriptorSystem >> classModelForGlorpTravelFile: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name
]

{ #category : #classes }
GlorpOrderedLinkDescriptorSystem >> classModelForGlorpTravelFolder: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #files collectionOf: GlorpTravelFile.
	aClassModel newAttributeNamed: #unordered collectionOf: GlorpTravelFile.
]

{ #category : #'initialize-release' }
GlorpOrderedLinkDescriptorSystem >> constructAllClasses [

	^(super constructAllClasses)
		add: GlorpTravelFolder;
		add: GlorpTravelFile;
		yourself
]

{ #category : #descriptors }
GlorpOrderedLinkDescriptorSystem >> descriptorForGlorpTravelFile: aDescriptor [
	| table |
	table := self tableNamed: 'FILES'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'name')
]

{ #category : #descriptors }
GlorpOrderedLinkDescriptorSystem >> descriptorForGlorpTravelFolder: aDescriptor [
	| table linkTable unorderedTable |
	table := self tableNamed: 'FOLDERS'.
	linkTable := self tableNamed: 'FOLDER_FILES_LINK'.
	unorderedTable := self tableNamed: 'UNORDERED_LINK'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name
		to: (table fieldNamed: 'name').
	(aDescriptor toManyMapping)
		attributeName: #files;
		useLinkTable;
		orderBy: [:e | (e getTable: 'FOLDER_FILES_LINK') getField: 'cindex'];
		writeTheOrderField;
		join: (Join from: (table fieldNamed: 'ID')
					to: (linkTable fieldNamed: 'FOLDER_ID')).
	(aDescriptor toManyMapping)
		attributeName: #unordered;
		useLinkTable;
		join: (Join from: (table fieldNamed: 'ID')
					to: (unorderedTable fieldNamed: 'FOLDER_ID')).
]

{ #category : #'initialize-release' }
GlorpOrderedLinkDescriptorSystem >> giveOrderedLinkTableNoPrimaryKeyFields [
	"The chief purpose of this system is to explore what happens when we do not set primary keys, thus causing the cindex order field to pecome one of the 'all fields' primary key that is then computed."

	| table |
	table := self tableNamed: 'FOLDER_FILES_LINK'.
	(table fieldNamed: 'FOLDER_ID')
		instVarNamed: 'isPrimaryKey' put: false.
	(table fieldNamed: 'FILE_ID')
		instVarNamed: 'isPrimaryKey' put: false.
	table instVarNamed: 'primaryKeyFields' put: nil.
]

{ #category : #tables }
GlorpOrderedLinkDescriptorSystem >> tableForFILES: aTable [
	(aTable createFieldNamed: 'ID' type: platform sequence) bePrimaryKey.
	aTable createFieldNamed: 'name' type: (platform varChar: 50)
]

{ #category : #tables }
GlorpOrderedLinkDescriptorSystem >> tableForFOLDERS: aTable [
	(aTable createFieldNamed: 'ID' type: platform sequence) bePrimaryKey.
	aTable createFieldNamed: 'name' type: (platform varChar: 50)
]

{ #category : #tables }
GlorpOrderedLinkDescriptorSystem >> tableForFOLDER_FILES_LINK: aTable [
	"The chief purpose of this system is to explore what happens when we do not set primary keys, thus causing the cindex order field to pecome one of the 'all fields' primary key that is then computed."

	| folderId fileId |
	folderId := aTable createFieldNamed: 'FOLDER_ID' type: platform int4.
	aTable addForeignKeyFrom: folderId to: ((self tableNamed: 'FOLDERS') fieldNamed: 'ID').
	fileId := aTable createFieldNamed: 'FILE_ID' type: platform int4.
	aTable addForeignKeyFrom: fileId to: ((self tableNamed: 'FILES') fieldNamed: 'ID').
	aTable createFieldNamed: 'cindex' type: platform int.
	folderId bePrimaryKey.
	fileId bePrimaryKey.
]

{ #category : #tables }
GlorpOrderedLinkDescriptorSystem >> tableForUNORDERED_LINK: aTable [
	| folderId fileId |
	folderId := aTable createFieldNamed: 'FOLDER_ID' type: platform int4.
	aTable addForeignKeyFrom: folderId
		to: ((self tableNamed: 'FOLDERS') fieldNamed: 'ID').
	fileId := aTable createFieldNamed: 'FILE_ID' type: platform int4.
	aTable addForeignKeyFrom: fileId
		to: ((self tableNamed: 'FILES') fieldNamed: 'ID')
]
