preparing
rebuildOn: aBaseExpression startingFrom: anExpression
	"Rebuild the expression on the new base. If we encounter anExpression, treat that as the base, and build only from that point up. e.g. if we have a.b.c.d and we rebuildOn: z startingFrom: b, then the result will be z.c.d"
	^self rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: nil.