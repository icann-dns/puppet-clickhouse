# @summary module to install and configure clickhouse server
#
# @param conf_dir path to configuration directory
# @param packages package name
# @param service service name
# @param default_password_sha256 default password sha256
# @param default_password default password
# @param log_level log level
# @param log_file log file
# @param errorlog_file error log file
# @param log_rotate_size log rotate size
# @param log_rotate_count log rotate count
# @param display_name display name
# @param http_port http port
# @param tcp_port tcp port
# @param https_port https port
# @param tcp_secure_port tcp secure port
# @param certificate_file certificate file
# @param private_key_file private key file
# @param dh_params_file dh params file
# @param verification_mode verification mode
# @param load_default_ca_file load default ca file
# @param cache_sessions cache sessions
# @param disable_protocols disable protocols
# @param prefer_server_ciphers prefer server ciphers
# @param allow_self_signed_client allow self signed client
# @param interserver_http_port interserver http port
# @param interserver_http_host interserver http host
# @param listen_hosts listen hosts
# @param max_connections max connections
# @param mark_cache_size mark cache size
# @param keep_alive_timeout keep alive timeout
# @param max_concurrent_queries max concurrent queries
# @param uncompressed_cache_size uncompressed cache size
# @param data_path data path
# @param tmp_path tmp path
# @param user_files_path user files path
# @param timezone timezone
# @param umask umask
# @param remotes remotes
# @param builtin_dictionaries_reload_interval builtin dictionaries reload interval
# @param max_session_timeout max session timeout
# @param default_session_timeout default session timeout
# @param query_log_db query log db
# @param query_log_table query log table
# @param query_log_partition_by query log partition by
# @param query_log_flush_interval query log flush interval
# @param part_log_enable part log enable
# @param part_log_db part log db
# @param part_log_table part log table
# @param part_log_flush_interval part log flush interval
# @param path_to_regions_hierarchy_file path to regions hierarchy file
# @param path_to_regions_names_files path to regions names files
# @param dictionaries_config dictionaries config
# @param dictionaries_config_source dictionaries config source
# @param compression_enable compression enable
# @param compression_min_part_size compression min part size
# @param compression_min_part_size_ratio compression min part size ratio
# @param compression_method compression method
# @param compression_level compression level
# @param distributed_ddl_enable distributed ddl enable
# @param distributed_ddl_path distributed ddl path
# @param distributed_ddl_profile distributed ddl profile
# @param max_suspicious_broken_parts max suspicious broken parts
# @param max_table_size_to_drop max table size to drop
# @param max_partition_size_to_drop max partition size to drop
# @param format_schema_path format schema path
# @param disable_internal_dns_cache disable internal dns cache
# @param default_networks default networks
# @param default_profile default profile
# @param default_quota default quota
# @param default_allow_databases default allow databases
# @param default_filter default filter
# @param users users
# @param zookeeper_servers zookeeper servers
# @param zookeeper_port zookeeper port
# @param top_level_domains_path top level domains path
# @param public_suffix_list_name public suffix list name
# @param roles a hash of roles and the grants provided
# @param profiles a hash of profiles and their settings
# @param quotas a hash of quotas and their settings
# @param enable_named_columns_in_function_tuple enable named columns in function tuple
#
class clickhouse (
  Stdlib::Unixpath                                $conf_dir = '/etc/clickhouse-server',
  Array[String[1]]                                $packages = ['clickhouse-server', 'clickhouse-odbc-bridge'],
  String[1]                                       $service = 'clickhouse-server',
  Optional[Pattern[/(?i:[a-f\d]+)/]]              $default_password_sha256 = undef,
  String                                          $default_password = '', # lint:ignore:params_empty_string_assignment
  Clickhouse::Log_level                           $log_level = 'trace',
  Stdlib::Unixpath                                $log_file = '/var/log/clickhouse-server/clickhouse-server.log',
  Stdlib::Unixpath                                $errorlog_file = '/var/log/clickhouse-server/clickhouse-server.err.log',
  Pattern[/(?i:\d+[mgk])/]                        $log_rotate_size = '100M',
  Integer[1]                                      $log_rotate_count = 10,
  String[1]                                       $display_name = 'production',
  Stdlib::Port                                    $http_port = 8123,
  Stdlib::Port                                    $tcp_port = 9000,
  Optional[Stdlib::Port]                          $https_port = undef,
  Optional[Stdlib::Port]                          $tcp_secure_port = undef,
  Stdlib::Unixpath                                $certificate_file = '/etc/clickhouse-server/server.crt',
  Stdlib::Unixpath                                $private_key_file = '/etc/clickhouse-server/server.key',
  Stdlib::Unixpath                                $dh_params_file = '/etc/clickhouse-server/dhparam.pem',
  String[1]                                       $verification_mode = 'none',
  Boolean                                         $load_default_ca_file = true,
  Boolean                                         $cache_sessions = true,
  Array[String[1]]                                $disable_protocols = ['sslv2', 'sslv3'],
  Boolean                                         $prefer_server_ciphers = true,
  Boolean                                         $allow_self_signed_client = false,
  Stdlib::Port                                    $interserver_http_port = 9009,
  Optional[Stdlib::Host]                          $interserver_http_host = undef,
  Array[Stdlib::IP::Address]                      $listen_hosts = ['127.0.0.1', '::1'],
  Integer[1]                                      $max_connections = 4096,
  Integer[1]                                      $mark_cache_size = 5368709120,
  Integer[1]                                      $keep_alive_timeout = 3,
  Integer[1]                                      $max_concurrent_queries = 100,
  Integer[1]                                      $uncompressed_cache_size = 8589934592,
  Stdlib::Unixpath                                $data_path = '/var/lib/clickhouse',
  Stdlib::Unixpath                                $tmp_path = '/var/lib/clickhouse/tmp',
  Stdlib::Unixpath                                $user_files_path = '/var/lib/clickhouse/user_files',
  Optional[String[1]]                             $timezone = undef,
  Pattern[/\d{3}/]                                $umask = '027',
  Integer[1]                                      $builtin_dictionaries_reload_interval = 3600,
  Integer[1]                                      $max_session_timeout = 3600,
  Integer[1]                                      $default_session_timeout = 60,
  String[1]                                       $query_log_db = 'system',
  String[1]                                       $query_log_table = 'query_log',
  String[1]                                       $query_log_partition_by = 'toYYYYMM(event_date)',
  Integer[1]                                      $query_log_flush_interval = 7500,
  Boolean                                         $part_log_enable = false,
  String[1]                                       $part_log_db = 'system',
  String[1]                                       $part_log_table = 'part_log',
  Integer[1]                                      $part_log_flush_interval = 7500,
  Optional[Stdlib::Unixpath]                      $path_to_regions_hierarchy_file = undef,
  Optional[Stdlib::Unixpath]                      $path_to_regions_names_files = undef,
  String[1]                                       $dictionaries_config = '*_dictionary.xml',
  Optional[Stdlib::Filesource]                    $dictionaries_config_source = undef,
  Boolean                                         $compression_enable = false,
  Integer                                         $compression_min_part_size = 10000000000,
  Float[0,1]                                      $compression_min_part_size_ratio = 0.01,
  String[1]                                       $compression_method = 'zstd',
  Integer[1,9]                                    $compression_level = 6,
  Boolean                                         $distributed_ddl_enable = true,
  Stdlib::Unixpath                                $distributed_ddl_path = '/clickhouse/task_queue/ddl',
  Optional[String[1]]                             $distributed_ddl_profile = undef,
  Optional[Integer[1]]                            $max_suspicious_broken_parts = undef,
  Optional[Integer]                               $max_table_size_to_drop = undef,
  Optional[Integer]                               $max_partition_size_to_drop = undef,
  Stdlib::Unixpath                                $format_schema_path = '/var/lib/clickhouse/format_schemas',
  Boolean                                         $disable_internal_dns_cache = false,
  Array[String[1]]                                $default_networks = ['::/0'],
  String[1]                                       $default_profile = 'default',
  String[1]                                       $default_quota = 'default',
  Optional[Array[String[1]]]                      $default_allow_databases = undef,
  Optional[Hash[String[1],Clickhouse::Db_filter]] $default_filter = undef,
  Hash[String[1], Clickhouse::User]               $users = {},
  Optional[Array[Stdlib::IP::Address]]            $zookeeper_servers = undef,
  Integer[0]                                      $zookeeper_port = 2181,
  Stdlib::Unixpath                                $top_level_domains_path = '/var/lib/clickhouse/top_level_domains',
  String[1]                                       $public_suffix_list_name = 'public_suffix_list.dat',
  Boolean                                         $enable_named_columns_in_function_tuple = false,
  Hash[String[1], Array[String[1]]]               $roles = {},
  Hash[String[1], Clickhouse::Profile]            $profiles = {},
  Hash[String[1], Clickhouse::Quota]              $quotas = {},
  Hash[String[1], Clickhouse::Remote]             $remotes = {
    'test_shard_localhost' => [{ 'replicas' => [{ 'host' => 'localhost', 'port' => 9000, },], },],
    'test_shard_localhost_secure' => [{ 'replicas' => [{ 'host'   => 'localhost', 'port'   => 9000, 'secure' => true, },], },],
  },
) {
  ensure_packages($packages)

  if $dictionaries_config_source {
    file { $conf_dir:
      ensure  => directory,
      source  => $dictionaries_config_source,
      recurse => remote,
      notify  => Service[$service],
      require => Package[$packages],
    }
  }
  file { "${conf_dir}/users.xml":
    ensure  => file,
    content => template('clickhouse/etc/users.xml.erb'),
    # TODO: add back in after testing
    # show_diff => false,
    notify  => Service[$service],
    require => Package[$packages],
  }
  file { "${conf_dir}/config.xml":
    ensure  => file,
    content => template('clickhouse/etc/config.xml.erb'),
    notify  => Service[$service],
    require => Package[$packages],
  }
  service { $service:
    ensure => running,
    enable => true,
  }
}
