delete-insert-update tests
testDeleteKeyValCopyInsertIsUpdate
	"By definition, the key value(s) must be the same for the delete and insert are merged into an update.  In this test, the deleted object has no values for the two non-key fields."

	self
		assertDeleteCopy: [:addr | GlorpAddress new id: addr id; yourself]
		ofInsertUpdatesFields: 2.