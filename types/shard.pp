type Clickhouse::Shard = Struct[{
  wieght               => Optional[Integer[1]],
  internal_replication => Optional[Boolean],
  replicas             => Array[Clickhouse::Replica],
}]
