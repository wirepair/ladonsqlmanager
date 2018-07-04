# LadonSQLManager
For use in [ory's ladon](https://github.com/ory/ladon) to not require the sql migrate or sqlx dependencies. This allows you to handle the database changes via external files/systems instead of the built in migration system. I needed this because I use goose and pgx and do not want any more SQL library dependencies. See the data/ directory for the necessary SQL files so you can add to your own database versioning pipeline. (Also included a goose compatible file).

While MySQL statements have been added, I did not test it because I do not use MySQL. Also note if you want to support your own database, you can call SQLManager.SetStatements(... ladonsqlmanager.Statements). But most likely you'll need to control how you create the database tables specific to your data store.


## Example
See the example directory for using with pgx. Assumes you've already created the tables via some external method.

### Author
[isaac dawson](https://twitter.com/_wirepair)