type Clickhouse::User = Struct[{
  password => String,
  networks => Array[String[1]],
  profile  => Optional[String[1]],
  quota    => Optional[String[1]],
}]
