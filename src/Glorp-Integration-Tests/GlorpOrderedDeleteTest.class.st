"
Test deleting objects with ordered links to others.  If the link table were to have an order field and no primary key, Glorp would compute the primary key to include the order field, but deletion from within the ordered collection would then automatically recompute the order field numbers of all later items.  We verify

"
Class {
	#name : #GlorpOrderedDeleteTest,
	#superclass : #GlorpSessionBasedTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #running }
GlorpOrderedDeleteTest >> setUp [
	super setUp.
	session system: (GlorpOrderedLinkDescriptorSystem forPlatform: session platform).
	session beginTransaction.
	session inUnitOfWorkDo:
		[session register: (GlorpTravelFolder new name: 'Test')].
]

{ #category : #running }
GlorpOrderedDeleteTest >> tearDown [

	session rollbackTransaction.
	super tearDown.
]

{ #category : #running }
GlorpOrderedDeleteTest >> testDeleteFromAndAddToOrderedCollection [

	| folderFromDB final |
	folderFromDB := session readOneOf: GlorpTravelFolder.
	session inUnitOfWorkDo:
		[session register: folderFromDB.
		1 to: 4 do: [:idx | folderFromDB files add: (GlorpTravelFile new name: 'File' , idx printString)]].
	session inUnitOfWorkDo:
		[session register: folderFromDB.
		folderFromDB files remove: (folderFromDB files detect: [:each | each name = 'File3']).
		folderFromDB files add: (GlorpTravelFile new name: 'A New File').
		folderFromDB files add: (GlorpTravelFile new name: 'Another New File').
		].
	final := (session refresh: folderFromDB) files.
	self assert: final size = 5.
	self assert: (final collect: #name) asSortedCollection asArray = #('A New File' 'Another New File' 'File1' 'File2' 'File4').
]

{ #category : #running }
GlorpOrderedDeleteTest >> testDeleteFromOrderedCollection [

	| folderFromDB final |
	folderFromDB := session readOneOf: GlorpTravelFolder.
	session inUnitOfWorkDo:
		[session register: folderFromDB.
		1 to: 4 do: [:idx | folderFromDB files add: (GlorpTravelFile new name: 'File' , idx printString)]].
	session inUnitOfWorkDo:
		[session register: folderFromDB.
		folderFromDB files remove: (folderFromDB files detect: [:each | each name = 'File3']).
		].
	final := (session refresh: folderFromDB) files.
	self assert: final size = 3.
	self assert: (final collect: #name) asSortedCollection asArray = #( 'File1' 'File2' 'File4').
]

{ #category : #running }
GlorpOrderedDeleteTest >> testDeleteFromUnorderedCollection [
	"Create 4 'files' in my main 'folder', save, then delete the third and save. Get the persistent state,
	verify that the unordered files collection is file1, file2 and file4."

	| folderFromDB final |
	folderFromDB := (session read: GlorpTravelFolder
				where: [:each | each name = 'Test']) first.
	session inUnitOfWorkDo:
		[session register: folderFromDB.
		1 to: 4 do: [:idx | folderFromDB unordered add: (GlorpTravelFile new name: 'File' , idx printString)]].
	(session refresh: folderFromDB) unordered.
	folderFromDB := (session read: GlorpTravelFolder where: [:each | each name = 'Test']) first.
	session inUnitOfWorkDo:
		[session register: folderFromDB.
		folderFromDB unordered remove: (folderFromDB unordered detect: [:each | each name = 'File3'])].
	final := (session refresh: folderFromDB) unordered.
	self assert: final size = 3.
	self assert: (final collect: #name) asSortedCollection asArray = #('File1' 'File2' 'File4').
]

{ #category : #running }
GlorpOrderedDeleteTest >> testRearrangeOrderedCollection [

	| folder newFolder |
	folder := GlorpTravelFolder new name: 'Fred'.
	4 to: 1 by: -1 do: [:idx | folder files add: (GlorpTravelFile new name: 'File' , idx printString)].
	session inUnitOfWorkDo: [
		session register: folder.
		folder files: (folder files asSortedCollection asOrderedCollection)].
	session reset.
	newFolder := session readOneOf: GlorpTravelFolder where: [:each | each name = 'Fred'].
	self assert: newFolder files asArray = newFolder files asSortedCollection asArray.
	self assert: newFolder files size = 4.
]

{ #category : #running }
GlorpOrderedDeleteTest >> testValidationOfSystemWithOrderFieldInPrimaryKey [
	"A mapping with a link table and which writes the order field must define primary key fields and must not include the order field as a primary key.  If we remove the primary key fields from the ordered link table, it will make all the fields primary, including the order field, so should raise a validation error."

	session system giveOrderedLinkTableNoPrimaryKeyFields.
	self
		should: [session system validate]
		raise: Error
		description:  'Validation of this system should have failed'.
]
