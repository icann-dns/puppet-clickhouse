# @summary Type definition for Clickhouse::User
type Clickhouse::User = Struct[{
    password => Optional[String[1]],
    networks => Array[String[1]],
    profile  => Optional[String[1]],
    quota    => Optional[String[1]],
    allow_db => Optional[Array[String[1]]],
    access_management => Optional[Boolean],
}]
