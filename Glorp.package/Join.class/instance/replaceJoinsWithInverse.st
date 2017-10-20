preparing
replaceJoinsWithInverse
	"Replace any actual Join objects we have with their inverse. Only useful if we have something that has mixed joins and general expressions, where we assume we don't want to mess with the general ones, because they're not field-level. As actual joins, we ignore this, because it will be done at the parent level"
	^self.