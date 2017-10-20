bound values
singleRowBindings
	"Whether binding or not, my printSQL method writes IS NULL if a lock field's value is nil since, in the where clause, the SQL must be WHERE ... IS NULL, not WHERE ... =NULL, and so at the least must not be offered as WHERE ... =? VALUES(..., nil) to PostgreSQL sockets.
	The lock fields come last, so if there is only one lock field then its final nil binding value can be provided for a lower layer to ignore, as was done in older Glorp.  However if there are two lock fields (rarer case), the nil value for the first gets bound to the second's ? in the SQL, its own value being ignored.  Therefore I must not bind nil to a lock field.
	An UpdateCommand cannot be arrayBound and returns false to supportsGroupWriting, so this is the only method where we have to handle lock fields."



	| basic lockFields lockValues |
	basic := super singleRowBindings.
	lockFields := row lockKeyFields.
	lockFields isEmpty ifTrue: [^basic].
	lockValues := OrderedCollection new: 2.
	lockFields do:
		[:each || fieldValue | fieldValue := row oldVersionAt: each ifAbsent: [nil].
		(fieldValue notNil and: [self canBind: fieldValue to: each type]) ifTrue:
			[lockValues add: fieldValue]].
	^basic, lockValues