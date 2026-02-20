# @summary module to install and configure clickhouse server
#
# @param conf_dir path to configuration directory
# @param packages package name
# @param service service name
# @param manage_package_repo whether to manage package repository
# @param default_password_sha256 default password sha256
# @param default_password default password
# @param max_memory_usage maximum memory usage
# @param use_uncompressed_cache use uncompressed cache
# @param joined_subquery_requires_alias joined subquery requires alias
# @param distributed_product_mode distributed product mode
# @param prefer_localhost_replica prefer localhost replica
# @param load_balancing load balancing
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
# @param default_duration default duration
# @param default_queries default queries
# @param default_errors default errors
# @param default_result_rows default result rows
# @param default_read_rows default read rows
# @param default_execution_time default execution time
# @param users users
# @param zookeeper_servers zookeeper servers
# @param zookeeper_port zookeeper port
# @param top_level_domains_path top level domains path
# @param public_suffix_list_name public suffix list name
# @param enable_named_columns_in_function_tuple enable named columns in function tuple
#
class clickhouse (
  Stdlib::Unixpath                                $conf_dir,
  Array[String[1]]                                $packages,
  String[1]                                       $service,
  Boolean                                         $manage_package_repo,
  Optional[Pattern[/(?i:[a-f\d]+)/]]              $default_password_sha256,
  String[0]                                       $default_password,
  Integer[0]                                      $max_memory_usage,
  Boolean                                         $use_uncompressed_cache,
  Boolean                                         $joined_subquery_requires_alias,
  Enum['deny','local','global','allow']           $distributed_product_mode,
  Boolean                                         $prefer_localhost_replica,
  Clickhouse::Load_balance                        $load_balancing,
  Clickhouse::Log_level                           $log_level,
  Stdlib::Unixpath                                $log_file,
  Stdlib::Unixpath                                $errorlog_file,
  Pattern[/(?i:\d+[mgk])/]                        $log_rotate_size,
  Integer[1]                                      $log_rotate_count,
  String[1]                                       $display_name,
  Stdlib::Port                                    $http_port,
  Stdlib::Port                                    $tcp_port,
  Optional[Stdlib::Port]                          $https_port,
  Optional[Stdlib::Port]                          $tcp_secure_port,
  Stdlib::Unixpath                                $certificate_file,
  Stdlib::Unixpath                                $private_key_file,
  Stdlib::Unixpath                                $dh_params_file,
  String[1]                                       $verification_mode,
  Boolean                                         $load_default_ca_file,
  Boolean                                         $cache_sessions,
  Array[String[1]]                                $disable_protocols,
  Boolean                                         $prefer_server_ciphers,
  Boolean                                         $allow_self_signed_client,
  Stdlib::Port                                    $interserver_http_port,
  Optional[Stdlib::Host]                          $interserver_http_host,
  Array[Stdlib::IP::Address]                      $listen_hosts,
  Integer[1]                                      $max_connections,
  Integer[1]                                      $mark_cache_size,
  Integer[1]                                      $keep_alive_timeout,
  Integer[1]                                      $max_concurrent_queries,
  Integer[1]                                      $uncompressed_cache_size,
  Stdlib::Unixpath                                $data_path,
  Stdlib::Unixpath                                $tmp_path,
  Stdlib::Unixpath                                $user_files_path,
  Optional[String[1]]                             $timezone,
  Pattern[/\d{3}/]                                $umask,
  Hash[String[1], Clickhouse::Remote]             $remotes,
  Integer[1]                                      $builtin_dictionaries_reload_interval,
  Integer[1]                                      $max_session_timeout,
  Integer[1]                                      $default_session_timeout,
  String[1]                                       $query_log_db,
  String[1]                                       $query_log_table,
  String[1]                                       $query_log_partition_by,
  Integer[1]                                      $query_log_flush_interval,
  Boolean                                         $part_log_enable,
  String[1]                                       $part_log_db,
  String[1]                                       $part_log_table,
  Integer[1]                                      $part_log_flush_interval,
  Optional[Stdlib::Unixpath]                      $path_to_regions_hierarchy_file,
  Optional[Stdlib::Unixpath]                      $path_to_regions_names_files,
  String[1]                                       $dictionaries_config,
  Optional[Stdlib::Filesource]                    $dictionaries_config_source,
  Boolean                                         $compression_enable,
  Integer                                         $compression_min_part_size,
  Float[0,1]                                      $compression_min_part_size_ratio,
  String[1]                                       $compression_method,
  Integer[1,9]                                    $compression_level,
  Boolean                                         $distributed_ddl_enable,
  Stdlib::Unixpath                                $distributed_ddl_path,
  Optional[String[1]]                             $distributed_ddl_profile,
  Optional[Integer[1]]                            $max_suspicious_broken_parts,
  Optional[Integer]                               $max_table_size_to_drop,
  Optional[Integer]                               $max_partition_size_to_drop,
  Stdlib::Unixpath                                $format_schema_path,
  Boolean                                         $disable_internal_dns_cache,
  Array[String[1]]                                $default_networks,
  String[1]                                       $default_profile,
  String[1]                                       $default_quota,
  Optional[Array[String[1]]]                      $default_allow_databases,
  Optional[Hash[String[1],Clickhouse::Db_filter]] $default_filter,
  Integer[0]                                      $default_duration,
  Integer[0]                                      $default_queries,
  Integer[0]                                      $default_errors,
  Integer[0]                                      $default_result_rows,
  Integer[0]                                      $default_read_rows,
  Integer[0]                                      $default_execution_time,
  Optional[Hash[String[1], Clickhouse::User]]     $users,
  Optional[Array[Stdlib::IP::Address]]            $zookeeper_servers,
  Integer[0]                                      $zookeeper_port,
  Stdlib::Unixpath                                $top_level_domains_path,
  String[1]                                       $public_suffix_list_name,
  Boolean                                         $enable_named_columns_in_function_tuple,
) {
  ensure_packages([$package])

  if $manage_package_repo {
    apt::source { 'clickhouse':
      location => 'http://repo.yandex.ru/clickhouse/deb/stable',
      release  => 'main/',
      repos    => '',
      key      => {
        id     => '9EBB357BC2B0876A774500C7C8F1E19FE0C56BD4',
      },
      include  => {
        src => false,
      },
    }
  }

  if $dictionaries_config_source {
    file { $conf_dir:
      ensure  => directory,
      source  => $dictionaries_config_source,
      recurse => remote,
      notify  => Service[$service],
      require => Package[$package],
    }
  }
  file { "${conf_dir}/users.xml":
    ensure  => file,
    content => template('clickhouse/etc/users.xml.erb'),
    notify  => Service[$service],
    require => Package[$package],
  }
  file { "${conf_dir}/config.xml":
    ensure  => file,
    content => template('clickhouse/etc/config.xml.erb'),
    notify  => Service[$service],
    require => Package[$package],
  }
  service { $service:
    ensure => running,
    enable => true,
  }
}
