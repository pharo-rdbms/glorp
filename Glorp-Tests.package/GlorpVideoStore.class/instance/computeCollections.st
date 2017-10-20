private
computeCollections
	customers do: [:each | each store: self].
	purchases := customers inject: #() into: [:sum :each | sum, each purchases].
	purchases do: [:each | each store: self].