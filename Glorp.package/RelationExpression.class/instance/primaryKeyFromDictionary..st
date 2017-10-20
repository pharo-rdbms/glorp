As yet unclassified
primaryKeyFromDictionary: aDictionary
	"Given a set of parameters, return a primary key suitable for retrieving our target. Do this only if the expression is for a primary key, and has no other conditions than the primary key one.  If the table's primary key is composite, return the array that will be needed with the found values in the right position and nils elsewhere.  (If unreferenced primaryKey fields are nillable, this could return a matching key.  A query with other values elsewhere will throw away the primary key, returning nil.  One without will "

	| left right field primaryKeyFields |
	relation = #AND ifTrue:
		[left := leftChild primaryKeyFromDictionary: aDictionary.
		left isNil ifTrue: [^nil].
		right := rightChild primaryKeyFromDictionary: aDictionary.
		right isNil ifTrue: [^nil].
		^self assembleCompositePrimaryKeyFrom: left and: right].
	relation = #= ifFalse: [^nil].
	field := leftChild fieldFromMeOrSubclasses.
	field isNil ifTrue: [^nil].
	field isGlorpExpression ifTrue: [^nil].
	field isPrimaryKey ifFalse: [^nil].
	primaryKeyFields := field table primaryKeyFields.
	^primaryKeyFields size > 1
		ifFalse: [rightChild valueIn: aDictionary]
		ifTrue:
			[(Array new: primaryKeyFields size withAll: DatabaseRow emptySlot)	"ensure no accidental nil-match"
				"field table may be alias with PK fields of original, so (field table primaryKeyFields indexOf: field) = 0"
				at: ((1 to: primaryKeyFields size) detect: [:i | (primaryKeyFields at: i) position = field position]) put: (rightChild valueIn: aDictionary);
				yourself]