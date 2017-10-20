copying
copy
	| new |
	new := super copy.
	"We need to make sure we copy these before the base gets set. This is horribly ugly."
	new selectListVersion: selectListVersion copy.
	new whereClauseVersion: whereClauseVersion copy.
	^new.