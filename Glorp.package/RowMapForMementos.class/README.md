This is a specialized version of RowMap for creating rowmaps out of the mementos in the undo/correspondence map. When doing partial writes we create a rowmap for the current state of the objects, then a rowmap for the original state, and difference the two.

The tricky part is that the mementos refer back to the original objects, so when we establish unification constraints between rows, they would establish them to original objects. This is wrong, and not trivial to debug.

So this rowmap keeps the correspondence map and knows that it has to compensate and get the memento for any related objects.
