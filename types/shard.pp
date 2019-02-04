type Clickhouse::Shard = Struct[{
  weight               => Optional[Integer[1]],
  internal_replication => Optional[Boolean],
  replicas             => Array[Clickhouse::Replica],
}]
