type Clickhouse::DatabaseFilter = Struct[{
  table       => String[1],
  tablefilter => Array[String[1]],
}]
