support
sort
	| sorter |
	sorter := GlorpRowSorter new getChildrenVia: #relatedItems.
	sorted := sorter sort: unsorted.