delete-insert-update tests
testDeleteOldCopyInsertNewIsUpdate
	"This shows how a user can mimic Glorp's memento management while deferring creating a session.  You capture a shallowCopy of the object of interest, then change the original as you wish.  By deleting the old copy and registering the changed original in the same session, you achieve the same effect as if you had registered the original in the session before you changed it:  the session treats it as an update.  The user is responsible for ensuring it is, i.e. an object of that key is already in the database.  Only the changed field would be regarded as needing update by the row if the deleted row were its oldVersion, but collapseMatchingInsertsAndDeletesFor: does not set this for fear a user could carelessly provide a deleted object that matched a changed field in the inserted object, so would not be updated.  Thus all non-key fields are always updated, even when not differing between delete and insert."

	self
		assertDeleteCopy: [:addr | addr shallowCopy]
		ofInsertUpdatesFields: 2.