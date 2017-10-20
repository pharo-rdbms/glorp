setup
createBasicFunctionsFor: anObject
	| exists notExists defaultFunctions |
	defaultFunctions := IdentityDictionary new.
	defaultFunctions
		at: #descending put: (PostfixFunction named: 'DESC');
		at: #distinct put: (PrefixFunction named: 'DISTINCT');
		at: #max put: (PrefixFunction named: 'MAX');
		at: #min put: (PrefixFunction named: 'MIN');
		at: #sum put: (PrefixFunction named: 'SUM');
		at: #avg put: (PrefixFunction named: 'AVG');
		at: #average put: (PrefixFunction named: 'AVG');
		at: #toChar: put: (PrefixFunction named: 'TO_CHAR');
		at: #not put: (PrefixFunction named: 'NOT');
		at: #, put: (InfixFunction named: '||');
		at: #countStar put: (StandaloneFunction named: 'COUNT(*)');
		at: #count put: (PrefixFunction named: 'COUNT');
		at: #similarTo: put: (InfixFunction named: 'LIKE');
		at: #between:and: put: (InfixFunction named: #('BETWEEN' 'AND'));
		at: #isNil
			put:
				((RelationExpression new)
						relation: #=;
						rightChild: nil asGlorpExpression);
		at: #notNil
			put:
				((RelationExpression new)
						relation: #<>;
						rightChild: nil asGlorpExpression);
		at: #isNIL
			put:
				((RelationExpression new)
						relation: #=;
						rightChild: nil asGlorpExpression);
		at: #notNIL
			put:
				((RelationExpression new)
						relation: #<>;
						rightChild: nil asGlorpExpression).
	exists := InfixFunction named: 'EXISTS'.
	anObject isNil ifFalse: [exists type: anObject boolean].
	defaultFunctions at: #exists: put: exists.
	notExists := InfixFunction named: 'NOT EXISTS'.
	anObject isNil ifFalse: [notExists type: anObject boolean].
	defaultFunctions at: #notExists: put: notExists.

	defaultFunctions
		at: #asUppercase put: (PrefixFunction named: 'UPPER');
		at: #asLowercase put: (PrefixFunction named: 'LOWER');
		at: #replace:with: put: (PrefixFunction named: 'REPLACE');
		at: #cast: put: ((Cast named: 'CAST') separator: ' AS ');
		at: #copyFrom:to: put: (SubstringFunction named: 'SUBSTR').

	^defaultFunctions.