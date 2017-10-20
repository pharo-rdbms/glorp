This builds raw data items rather than persistent objects with descriptors. Used if we do something like 
  aQuery retrieve: [:each | each address streetName].
giving us back simple data objects.
This makes building them quite simple.