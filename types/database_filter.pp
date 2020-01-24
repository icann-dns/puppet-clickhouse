type Clickhouse::Database_filter = Struct[{
  database       => String[1],
  databasefilter => Array[Clickhouse::Table_filter],
}]
