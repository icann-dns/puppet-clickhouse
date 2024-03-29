# @summary module to install and configure clickhouse server
#
# @param package clickhouse server package to install
# @param conf_dir main config directory
#
class clickhouse (
  Stdlib::Unixpath                                $conf_dir,
  String[1]                                       $package,
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
    file {$conf_dir:
      ensure  => directory,
      source  => $dictionaries_config_source,
      recurse => remote,
      notify  => Service[$service],
      require => Package[$package],
    }
  }
  file {"${conf_dir}/users.xml":
    ensure  => file,
    content => template('clickhouse/etc/users.xml.erb'),
    notify  => Service[$service],
    require => Package[$package],
  }
  file {"${conf_dir}/config.xml":
    ensure  => file,
    content => template('clickhouse/etc/config.xml.erb'),
    notify  => Service[$service],
    require => Package[$package],
  }
  service {$service:
    ensure => running,
    enable => true,
  }
}
