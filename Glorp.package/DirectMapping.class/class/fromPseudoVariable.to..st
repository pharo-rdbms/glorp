instance creation
fromPseudoVariable: attributeName to: field

	^self fromPseudoVariable: attributeName
			type: field impliedSmalltalkType
			to: field