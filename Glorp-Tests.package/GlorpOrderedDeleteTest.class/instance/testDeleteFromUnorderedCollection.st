running
testDeleteFromUnorderedCollection
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