functions
initializeFunctions
	| baseExists dbSpecificExists selectList baseNotExists dbSpecificNotExists |
	super initializeFunctions.
	functions at: #regexMatches: put: (PrefixFunction named: 'REGEXP_LIKE').

	"Oracle doesn't allow functions like EXISTS in a field list, but will allow a select there as an argument to a function, such as DECODE. So print it that way if we're in the select list."
	baseExists := functions at: #exists:.
	dbSpecificExists := DualRoleFunction new.
	dbSpecificExists function: '#exists:'.
	dbSpecificExists whereClauseVersion: baseExists.
	selectList := PrefixFunction named: 'DECODE'.
	selectList argumentModifierBlock: [:function :args | 
		function base: args first.
		Array with: 'x' asGlorpExpression with: 1 asGlorpExpression with: 0 asGlorpExpression].
	selectList type: baseExists type.
	dbSpecificExists selectListVersion: selectList.
	dbSpecificExists type: baseExists type.
	functions at: #exists: put: dbSpecificExists.

	"And similarly NOT EXISTS"
	baseNotExists := functions at: #notExists:.
	dbSpecificNotExists := DualRoleFunction new.
	dbSpecificNotExists function: '#notExists:'.
	dbSpecificNotExists whereClauseVersion: baseNotExists.
	selectList := PrefixFunction named: 'DECODE'.
	selectList argumentModifierBlock: [:function :args | 
		function base: args first.
		Array with: 'x' asGlorpExpression with: 0 asGlorpExpression with: 1 asGlorpExpression].
	selectList type: baseNotExists type.
	dbSpecificNotExists selectListVersion: selectList.
	dbSpecificNotExists type: baseExists type.
	functions at: #notExists: put: dbSpecificNotExists.