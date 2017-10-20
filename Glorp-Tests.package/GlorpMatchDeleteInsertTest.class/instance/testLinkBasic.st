running
testLinkBasic
	"Just a smoke test to ensure that the general setup is okay."

	| workers exampleWorkers |
	workers := session read: GlorpTaskedWorker orderBy: #name.
	exampleWorkers := (GlorpTaskedWorker example1) asSortedCollection: [:a :b| a name < b name].
	self assert: (workers size = exampleWorkers size).
	self assert: ((workers at: 3) isSimilarToWorker: (exampleWorkers at: 3)).