# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

* [`clickhouse`](#clickhouse): module to install and configure clickhouse server

## Classes

### clickhouse

module to install and configure clickhouse server

#### Parameters

The following parameters are available in the `clickhouse` class.

##### `package`

Data type: `String[1]`

clickhouse server package to install

##### `conf_dir`

Data type: `Stdlib::Unixpath`

main config directory

##### `service`

Data type: `String[1]`



##### `default_password_sha256`

Data type: `Optional[Pattern[/(?i:[a-f\d]+)/]]`



##### `default_password`

Data type: `String[0]`



##### `max_memory_usage`

Data type: `Integer[0]`



##### `use_uncompressed_cache`

Data type: `Boolean`



##### `load_balancing`

Data type: `Clickhouse::Load_balance`



##### `log_level`

Data type: `Clickhouse::Log_level`



##### `log_file`

Data type: `Stdlib::Unixpath`



##### `errorlog_file`

Data type: `Stdlib::Unixpath`



##### `log_rotate_size`

Data type: `Pattern[/(?i:\d+[mgk])/]`



##### `log_rotate_count`

Data type: `Integer[1]`



##### `display_name`

Data type: `String[1]`



##### `http_port`

Data type: `Stdlib::Port`



##### `tcp_port`

Data type: `Stdlib::Port`



##### `https_port`

Data type: `Optional[Stdlib::Port]`



##### `tcp_secure_port`

Data type: `Optional[Stdlib::Port]`



##### `certificate_file`

Data type: `Stdlib::Unixpath`



##### `private_key_file`

Data type: `Stdlib::Unixpath`



##### `dh_params_file`

Data type: `Stdlib::Unixpath`



##### `verification_mode`

Data type: `String[1]`



##### `load_default_ca_file`

Data type: `Boolean`



##### `cache_sessions`

Data type: `Boolean`



##### `disable_protocols`

Data type: `Array[String[1]]`



##### `prefer_server_ciphers`

Data type: `Boolean`



##### `allow_self_signed_client`

Data type: `Boolean`



##### `interserver_http_port`

Data type: `Stdlib::Port`



##### `interserver_http_host`

Data type: `Optional[Stdlib::Host]`



##### `listen_hosts`

Data type: `Array[Stdlib::IP::Address]`



##### `max_connections`

Data type: `Integer[1]`



##### `mark_cache_size`

Data type: `Integer[1]`



##### `keep_alive_timeout`

Data type: `Integer[1]`



##### `max_concurrent_queries`

Data type: `Integer[1]`



##### `uncompressed_cache_size`

Data type: `Integer[1]`



##### `data_path`

Data type: `Stdlib::Unixpath`



##### `tmp_path`

Data type: `Stdlib::Unixpath`



##### `user_files_path`

Data type: `Stdlib::Unixpath`



##### `timezone`

Data type: `Optional[String[1]]`



##### `umask`

Data type: `Pattern[/\d{3}/]`



##### `remotes`

Data type: `Hash[String[1], Clickhouse::Remote]`



##### `builtin_dictionaries_reload_interval`

Data type: `Integer[1]`



##### `max_session_timeout`

Data type: `Integer[1]`



##### `default_session_timeout`

Data type: `Integer[1]`



##### `query_log_db`

Data type: `String[1]`



##### `query_log_table`

Data type: `String[1]`



##### `query_log_partition_by`

Data type: `String[1]`



##### `query_log_flush_interval`

Data type: `Integer[1]`



##### `part_log_enable`

Data type: `Boolean`



##### `part_log_db`

Data type: `String[1]`



##### `part_log_table`

Data type: `String[1]`



##### `part_log_flush_interval`

Data type: `Integer[1]`



##### `path_to_regions_hierarchy_file`

Data type: `Optional[Stdlib::Unixpath]`



##### `path_to_regions_names_files`

Data type: `Optional[Stdlib::Unixpath]`



##### `dictionaries_config`

Data type: `String[1]`



##### `dictionaries_config_source`

Data type: `Optional[Stdlib::Filesource]`



##### `compression_enable`

Data type: `Boolean`



##### `compression_min_part_size`

Data type: `Integer`



##### `compression_min_part_size_ratio`

Data type: `Float[0,1]`



##### `compression_method`

Data type: `String[1]`



##### `compression_level`

Data type: `Integer[1,9]`



##### `distributed_ddl_enable`

Data type: `Boolean`



##### `distributed_ddl_path`

Data type: `Stdlib::Unixpath`



##### `distributed_ddl_profile`

Data type: `Optional[String[1]]`



##### `max_suspicious_broken_parts`

Data type: `Optional[Integer[1]]`



##### `max_table_size_to_drop`

Data type: `Optional[Integer[1]]`



##### `format_schema_path`

Data type: `Stdlib::Unixpath`



##### `disable_internal_dns_cache`

Data type: `Boolean`



##### `default_networks`

Data type: `Array[String[1]]`



##### `default_profile`

Data type: `String[1]`



##### `default_quota`

Data type: `String[1]`



##### `default_duration`

Data type: `Integer[0]`



##### `default_queries`

Data type: `Integer[0]`



##### `default_errors`

Data type: `Integer[0]`



##### `default_result_rows`

Data type: `Integer[0]`



##### `default_read_rows`

Data type: `Integer[0]`



##### `default_execution_time`

Data type: `Integer[0]`



##### `users`

Data type: `Optional[Hash[String[1], Clickhouse::User]]`



