functions
initializeFunctions
	| baseExists dbSpecificExists selectList baseNotExists dbSpecificNotExists |
	super initializeFunctions.
	functions
		at: #, put: (InfixFunction named: '+');
		at: #copyFrom:to: put: (SubstringFunction named: 'SUBSTRING');
		at: #objectId put: (PrefixFunction named: 'OBJECT_ID');
		at: #columnPropertySchema:property: put: ((PrefixFunction named: 'COLUMNPROPERTY') type: self integer);
		at: #convertTo: put: ((PrefixFunction named: 'CONVERT')). "CONVERT(toType, aThing)"

	"Like Oracle, SQL Server doesn't allow functions like EXISTS in a field list,
	but will allow a select there as an argument to a function, such as CASE.
	So print it that way if we're in the select list."

	baseExists := functions at: #exists:.
	dbSpecificExists := DualRoleFunction new.
	dbSpecificExists function: '#exists:'.
	dbSpecificExists whereClauseVersion: baseExists.
	selectList := Case new argumentTypes: (Array with: (self varchar: 1) with: self integer with: self integer).
	selectList argumentModifierBlock: [:function :args | 
		function base: args first.
		Array with: 'x' asGlorpExpression with: 1 asGlorpExpression with: 0 asGlorpExpression].
	dbSpecificExists selectListVersion: selectList.
	dbSpecificExists type: self integer.
	functions at: #exists: put: dbSpecificExists.

	"And similarly NOT EXISTS"
	baseNotExists := functions at: #notExists:.
	dbSpecificNotExists := DualRoleFunction new.
	dbSpecificNotExists function: '#notExists:'.
	dbSpecificNotExists whereClauseVersion: baseNotExists.
	selectList := Case new argumentTypes: (Array with: (self varchar: 1) with: self integer with: self integer).
	selectList argumentModifierBlock: [:function :args | 
		function base: args first.
		Array with: 'x' asGlorpExpression with: 0 asGlorpExpression with: 1 asGlorpExpression].
	dbSpecificNotExists selectListVersion: selectList.
	dbSpecificNotExists type: self integer.
	functions at: #notExists: put: dbSpecificNotExists.