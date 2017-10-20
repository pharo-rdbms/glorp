instance creation
fromPseudoVariable: attributeName type: aClass to: field

	^(self new)
		attributeName: attributeName;
		field: field;
		beForPseudoVariable