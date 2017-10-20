private
nextSequenceNumberSelectString
	^'SELECT ' , self qualifiedName , '.NEXTVAL FROM DUAL'