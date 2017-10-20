sequencing
dropString
	^'DELETE FROM RDB$GENERATORS
        WHERE RDB$GENERATOR_NAME=''', self qualifiedName, ''''.