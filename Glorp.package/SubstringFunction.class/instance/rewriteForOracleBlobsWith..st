rewriting
rewriteForOracleBlobsWith: mainArgument
	"For Oracle blobs, we can't query with a normal substring function, but rather have to use the DBMS_LOB function, whose arguments are backwards. Further, we don't seem to be able to compare to byte-arrays, so turn it into a string."
	| oldBase template startPosition endPosition length |
	(mainArgument isGlorpExpression and: [mainArgument isConstantExpression]) ifFalse: [^self].
	function := 'UTL_RAW.CAST_TO_VARCHAR2'.
	startPosition := arguments first value.
	endPosition := arguments last value.
	length := arguments last value.
	arguments := #().
	oldBase := base.
	template := PrefixFunction named: 'DBMS_LOB.SUBSTR'.
	base := template createFor: (Array with: length asGlorpExpression with: startPosition asGlorpExpression) withBase: oldBase symbol: #dbmsLobSubstr.