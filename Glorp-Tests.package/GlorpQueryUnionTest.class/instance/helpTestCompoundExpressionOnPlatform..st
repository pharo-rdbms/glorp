support
helpTestCompoundExpressionOnPlatform: platform
	| query union |
	platform useBinding: false.
	query := Query read: GlorpAddress.
	union := query unionAll: query.
	union session: session.
	^(union sqlWith: Dictionary new) sqlString.