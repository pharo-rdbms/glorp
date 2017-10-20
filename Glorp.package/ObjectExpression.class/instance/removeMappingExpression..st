private/accessing
removeMappingExpression: anExpression
	"Private. Normally you would never do this, but in the case of an anySatisfy: or allSatisfy: we want to have each of them as distinct joins, so we will remove the entry from the mappingExpression of the base, making sure that relationship will not be used for anything else. Since any/allSatisfy: is the only valid use of a collection relationship, we don't have to worry about whether it was used for something else earlier."

	self mappingExpressions removeKey: anExpression name.