# glorp
Generic Lightweight Obect Relational Persistence (for Pharo)

Glorp is a full-featured Object-Relational Mapper which offers a number of features to reduce the 'impedance' between working with objects and storing them in flat tables. Amongst those features, you'll find some features saving you from writing SQL queries by hand, managing transactions that rollback the changes to the objects in your image or commit them to the database, writing simple and complex queries using plain Pharo syntax, and other features that we will cover in this introduction chapter and in the advanced topics chapter.

This port of Glorp is based on VisualWorks Glorp version 8.0.1.

Further information on loading and using Glorp is available in "Object-Relational Persistance with Glorp", available from http://books.pharo.org/

To load Glorp:

```smalltalk
Metacello new 
	repository: 'github://pharo-rdbms/glorp';
	baseline: 'Glorp';
	load.
```

Note that the required database drivers must be loaded separately.

To load Glorp with the UDBC SQLite drivers:

```smalltalk
Metacello new 
	repository: 'github://pharo-rdbms/glorp-sqlite3';
	baseline: 'GlorpSQLite';
	load.
```

