# @summary Type definition for Clickhouse::Quota
type Clickhouse::Quota = Struct[
  {
    'intervals' => Array[Clickhouse::Quota::Interval],
    'keyed' => Optional[Enum['client_key', 'ip_address']],
  }
]
