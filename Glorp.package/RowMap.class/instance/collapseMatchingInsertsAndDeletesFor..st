private/deletion
collapseMatchingInsertsAndDeletesFor: eachTablesRows
	"Find any inserts and deletes for these rows which have the same primary key. We expect these to be link table rows, because for rows that map to objects, Glorp-managed object identity should ensure this never happens (i.e. it can happen if, but only if, a user explicitly deletes an object and adds another, giving it the same key, in the same transaction). Force the insert to be an update instead (by returning it to the calling method, which will force that to happen) and remove the deletion."

	| deletions updates matchedDeletions deletion |
	(self isSuitableForCollapsing: eachTablesRows) ifFalse: [^#()].
	deletions := Dictionary new: 50.
	updates := OrderedCollection new.
	eachTablesRows do: [:each | each forDeletion ifTrue: [
		deletions at: (each primaryKey) put: each]].
	deletions isEmpty ifTrue: [^#()].
	matchedDeletions := IdentitySet new: deletions size.

	eachTablesRows do:
		[:each || pk |
		pk := each primaryKey.
		((deletions includesKey: pk) and: [each forDeletion not]) ifTrue:
			[deletion := deletions at: pk.
			(matchedDeletions includes: deletion) ifFalse:
				["If we could trust the user always to delete the right object, or one with no field values accidentally matching a changed new row value, then we could do
				each withAllFieldsIn: deletion. 
then add
				each fieldsNeedingUpdate isEmpty or:
to the no-op check following.  Lacking this certainty, we do not set the deletion row to be the oldVersion of the each row, thus ensuring the update command will update all the non-primaryKey fields whether they differ between deletion and each or not."
				"Now here's a very special case. If there are no non-primary key fields, then we collapse this down to a no-op. We've deleted and re-inserted with exactly the same information. However, we still leave it in the list of updated rows, because we want it to be put into the session cache if it's not already there at the end."
				each table primaryKeyFields size = each fields size
					ifTrue: [self privateDeleteRow: each].
				"Make the row an update, with the deletion as its old value."
				updates add: each.
				matchedDeletions add: deletion.
				self privateDeleteRow: deletion]]].
	^updates