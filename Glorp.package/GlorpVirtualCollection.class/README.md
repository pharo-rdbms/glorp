This represents a virtual collection, i.e. one that we haven't really read into memory yet. It responds to a reasonable subset of collection protocol, and will read the elements into memory only when necessary. So, e.g. a select: operation takes a query block, and is equivalent to AND:ing that query block to the main query.

To create a virtual collection, ask the session for one. e.g. session virtualCollectionOf: AClass.

This is an initial version which will read in the objects fairly eagerly. An optimization might be to defer certain types of operations depending on whether the block can be evaluated into SQL or not. e.g.
  collect: [:each | each name]
can be turned into a retrieve: operation. But 
  collect: [:each | each printString]
cannot. We could try to check the block for operations like collect: and detect:, deferring the point at which the objects will be read in.

Handling of ordering is also a little bit funny. The blocks we like for ordering aren't compatible with sortedCollection type blocks. It'd be nice to be more compatible.

