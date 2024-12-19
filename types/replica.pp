type Clickhouse::Replica = Struct[{
    host     => Stdlib::Host,
    port     => Stdlib::Port,
    secure   => Optional[Boolean],
    user     => Optional[String[1]],
    password => Optional[String[1]],
}]
