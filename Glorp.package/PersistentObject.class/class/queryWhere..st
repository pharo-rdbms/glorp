*Glorp
queryWhere: aBlock
	"Return a Query object that will query the database for all objects of this class satisfying aBlock. The block has to be a query block, meaning you can't execute arbitrary code, but rather it will be analyzed and used to generate SQL. If you want to just return the objects, use findWhere: instead. The advantage of this is that you can use this to get a basic query, but then modify it before executing it, e.g. using AND: or OR:."
	"Person queryWhere: [:each | (each name = 'John Doe') & (each address houseNum = 1000)]"

	^Query read: self where: aBlock.