# GLORP
[![Pharo](https://img.shields.io/static/v1?style=for-the-badge&message=Pharo&color=3297d4&logo=Harbor&logoColor=FFFFFF&label=)](https://www.pharo.org) 
[![Glorp](https://img.shields.io/static/v1?style=for-the-badge&message=Glorp&color=044a64&logo=amazondynamodb&logoColor=FFFFFF&label=)](https://glorp.org)

[![Unit Tests](https://github.com/pharo-rdbms/glorp/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/pharo-rdbms/glorp/actions/workflows/unit-tests.yml)
[![PostgreSQL Integration Tests](https://github.com/pharo-rdbms/glorp/actions/workflows/postgreSQL-integration-tests.yml/badge.svg)](https://github.com/pharo-rdbms/glorp/actions/workflows/postgreSQL-integration-tests.yml)
[![SQLite3 Integration Tests](https://github.com/pharo-rdbms/glorp/actions/workflows/sqlite3-integration-tests.yml/badge.svg)](https://github.com/pharo-rdbms/glorp/actions/workflows/sqlite3-integration-tests.yml)
[![Coverage Status](https://codecov.io/github/pharo-rdbms/glorp/coverage.svg?branch=master)](https://codecov.io/gh/pharo-rdbms/glorp/branch/master)

[![Pharo 8.0](https://img.shields.io/badge/Pharo-8.0-informational)](https://pharo.org)
[![Pharo 9.0](https://img.shields.io/badge/Pharo-9.0-informational)](https://pharo.org)
[![Pharo 10](https://img.shields.io/badge/Pharo-10-informational)](https://pharo.org)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-informational)](https://pharo.org)
[![Pharo 12](https://img.shields.io/badge/Pharo-12-informational)](https://pharo.org)

## Generic Lightweight Object Relational Persistence (for Pharo)

Glorp is a full-featured Object-Relational Mapper which offers a number of features to reduce the 'impedance' between working with objects and storing them in flat tables. Amongst those features, you'll find some features saving you from writing SQL queries by hand, managing transactions that rollback the changes to the objects in your image or commit them to the database, writing simple and complex queries using plain Pharo syntax, and other features that we will cover in this introduction chapter and in the advanced topics chapter.

This port of Glorp is based on VisualWorks Glorp version 8.0.1.

Further information on loading and using Glorp is available in "Object-Relational Persistence with Glorp", available from http://books.pharo.org/

To load Glorp itself:

```smalltalk
Metacello new
	repository: 'github://pharo-rdbms/glorp';
	baseline: 'Glorp';
	load.
```

Note that Glorp requires database drivers for the actual database connectivity:
- For SQLite3, see [Pharo-SQLite3](https://github.com/pharo-rdbms/Pharo-SQLite3). Use its Metacello snippet to load both Glorp and the driver in one go.
- For PostgreSQL, see [P3](https://github.com/svenvc/P3). As per its README, load the driver after loading Glorp itself.
- On Windows, for Oracle and SQLServer, see [PharoADO](https://github.com/eftomi/PharoADO). By default its Metacello snippet loads Glorp and the driver.  

## ActiveRecord extensions

A recent update adds compatibility with Rails style ActiveRecord database schemas.  The Rails folks realized that if a database schema follows some simple conventions, then mapping to objects becomes much easier.  The complete ActiveRecord naming convention is detailed at https://guides.rubyonrails.org/active_record_basics.html The following was mostly taken from there.

### Tables and Classes

ActiveRecord will pluralize your class names to find the respective database table. So, for a class Book, you should have a database table called books. The ActiveRecord pluralization mechanisms are very powerful, being capable of pluralizing (and singularizing) both regular and irregular words. When using class names composed of two or more words, the model class name should follow the Ruby conventions, using the CamelCase form, while the table name must contain the words separated by underscores. Examples:

* Model Class - Singular with the first letter of each word capitalized (e.g., BookClub).
* Database Table - Plural with underscores separating words (e.g., book_clubs).

| Model / Class  |  Table / Schema |
|----------------- |--------------------|
| Article  |  articles |
| LineItem |   line_items |
| Deer  |  deer |
| Mouse  |  mice |
| Person |   people |

Table pluralization can be disabled by setting pluralizeTables on the descriptor system.

### Schema Conventions
Active Record uses naming conventions for the columns in database tables, depending on the purpose of these columns.

* **Foreign keys** - These fields should be named following the pattern singularized_table_name_id (e.g., item_id, order_id). These are the fields that Active Record will look for when you create associations between your models.
* **Primary keys** - By default, Active Record will use an integer column named id as the table's primary key (bigint for PostgreSQL and MySQL, integer for SQLite). Primary keys defined as strings will be generated with GUIDs.

There are also some optional column names that will add additional features to Active Record instances:

**created_at** - Automatically gets set to the current date and time when the record is first created.

**updated_at** - Automatically gets set to the current date and time whenever the record is created or updated.

**deleted_at** - When present, delete methods will just update this field to the current timestamp and **ActiveRecordQuery** will ignore records where deleted_at is not null.

**type** - Specifies that the model uses Single Table Inheritance.

**order** - Specifies the order of records when in a to-many relationship.  In the event of a link table, the order field is on the link table.  A number of synonyms are used to infer ordering fields.  By default fields named position sequence_no seq_no sequence_num seq_num sort_no display_position display_order order sort_value sort_key sort are inferred to be sort keys.  This can be changed in the **ActiveRecordDescriptorSystem**.

The ActiveRecord mappings are new and may contain bugs.  There are some tests but more are needed. Submission of tests, bug reports, or fixes are welcome.  

ActiveRecord support was added by Todd Blanchard
