type Clickhouse::DatabaseFilter = Struct[{
  database       => String[1],
  databasefilter => Array[Clickhouse::TableFilter],
}]
