instance creation
basedOn: anExpression
	"The defining characteristic of a general subselect is that it doesn't care what it's based on. The base is just a convenient place to hang an independent expression. So make sure we're built on a true base, which won't print confusing stuff for us"
	^self new base: anExpression ultimateBaseExpression