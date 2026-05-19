# @summary Type definition for Clickhouse::Log_level
type Clickhouse::Log_level = Enum[
  'none',
  'fatal',
  'critical',
  'error',
  'warning',
  'notice',
  'information',
  'debug',
  'trace',
]
