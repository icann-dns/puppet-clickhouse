type Clickhouse::Quota::Interval = Struct[
  {
    'duration' => Integer[1],
    'queries' => Optional[Integer[0]],
    'queries_selects' => Optional[Integer[0]],
    'queries_inserts' => Optional[Integer[0]],
    'errors' => Optional[Integer[0]],
    'result_rows' => Optional[Integer[0]],
    'result_bytes' => Optional[Integer[0]],
    'read_rows' => Optional[Integer[0]],
    'read_bytes' => Optional[Integer[0]],
    'execution_time' => Optional[Integer[0]],
    'written_bytes' => Optional[Integer[0]],
    'failed_sequential_authentications' => Optional[Integer[0]]
  }
]
