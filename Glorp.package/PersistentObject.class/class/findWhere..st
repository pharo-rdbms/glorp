*Glorp
findWhere: aBlock
	"Query the database for all objects of this class satisfying aBlock. The block has to be a query block, meaning you can't execute arbitrary code, but rather it will be analyzed and used to generate SQL."
	"Person findWhere: [:each | (each name = 'John Doe') & (each address houseNum = 1000)]"

	^self getSession read: self where: aBlock.