callbacks
joinFor: aMapping toTables: toTables fromConstraints: fromConstraints toConstraints: toConstraints
	"Return the join to be used for aMapping. The set of tables we expect this to be related to, and the constraints from this table, and to this table are provided as possibly useful input."
	| numberOfConstraints |
	numberOfConstraints := (Set new addAll: toConstraints; addAll: fromConstraints; yourself) size.
	numberOfConstraints = 0 ifTrue: [
		CannotAutomaticallyDetermineJoin new 
			tables: toTables;
			constraints: (toConstraints, fromConstraints);
			signal: 'Cannot automatically determine join, no constraints found.'].
	numberOfConstraints > 1 ifTrue: [
		CannotAutomaticallyDetermineJoin new
			tables: toTables;
			constraints: (toConstraints, fromConstraints);
			signal: 'Cannot automatically determine join, too many constraints found.'].
	^toConstraints isEmpty ifTrue: [fromConstraints first asReverseJoin] ifFalse: [toConstraints first asJoin]