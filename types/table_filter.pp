# @summary Type definition for Clickhouse::Table_filter
type Clickhouse::Table_filter = Struct[{
    table       => String[1],
    tablefilter => String[1],
}]
