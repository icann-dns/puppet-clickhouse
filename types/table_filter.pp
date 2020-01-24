type Clickhouse::Table_filter = Struct[{
  table       => String[1],
  tablefilter => Array[String[1]],
}]
