api/queries
deleteAll: aCollection

 	aCollection do: [:each | self delete: each]