This class serves as a key for a dictionary containing two sub-keys, where we want to be able to look up based on the identity of both sub-keys paired together. This is used primarily for many-to-many mappings indexing into rowmaps, where we want to key the row by the identity of the object that determines it, but there are two of them.

Instance Variables:

key1	<Object>	One sub-key.
key2	<Object>	The other sub-key.'