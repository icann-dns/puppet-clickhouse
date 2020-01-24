type Clickhouse::TableFilter = Struct[{
  table       => String[1],
  tablefilter => Array[String[1]],
}]
