require 'spec_helper'

describe 'clickhouse' do
  let(:node) { 'clickhouse.example.com' }
  let(:params) { {} }

  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  # This will need to get moved
  # it { pp catalogue.resources }
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'check default config' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('clickhouse-server') }
        it { is_expected.to contain_service('clickhouse-server') }
        it do
          is_expected.to contain_file(
            '/etc/clickhouse-server/users.xml',
          ).with_ensure('file').with_content(
            %r{<max_memory_usage>10000000000</max_memory_usage>},
          ).with_content(
            %r{<use_uncompressed_cache>0</use_uncompressed_cache>},
          ).with_content(
            %r{<load_balancing>random</load_balancing>},
          )
        end
        it do
          is_expected.to contain_file(
            '/etc/clickhouse-server/config.xml',
          ).with_ensure('file').with_content(
            %r{
            \s+<logger>
            \s+<level>trace</level>
            \s+<log>/var/log/clickhouse-server/clickhouse-server.log</log>
            \s+<errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>
            \s+<size>100M</size>
            \s+<count>10</count>
            \s+</logger>
            }x,
          ).with_content(
            %r{<display_name>production</display_name>},
          ).with_content(
            %r{<http_port>8123</http_port>},
          ).with_content(
            %r{<tcp_port>9000</tcp_port>},
          ).without_content(
            %r{<https_port>},
          ).without_content(
            %r{<tcp_secure_port>},
          ).with_content(
            %r{
            <openSSL>
            \s+<server>
            \s+<certificateFile>/etc/clickhouse-server/server.crt</certificateFile>
            \s+<privateKeyFile>/etc/clickhouse-server/server.key</privateKeyFile>
            \s+<dhParamsFile>/etc/clickhouse-server/dhparam.pem</dhParamsFile>
            \s+<verificationMode>none</verificationMode>
            \s+<loadDefaultCAFile>true</loadDefaultCAFile>
            \s+<cacheSessions>true</cacheSessions>
            \s+<disableProtocols>sslv2,sslv3</disableProtocols>
            \s+<preferServerCiphers>true</preferServerCiphers>
            \s+</server>
            \s+<client>
            \s+<loadDefaultCAFile>true</loadDefaultCAFile>
            \s+<cacheSessions>true</cacheSessions>
            \s+<disableProtocols>sslv2,sslv3</disableProtocols>
            \s+<preferServerCiphers>true</preferServerCiphers>
            \s+<invalidCertificateHandler>
            \s+<name>RejectCertificateHandler</name>
            \s+</invalidCertificateHandler>
            \s+</client>
            \s+</openSSL>
            }x,
          ).with_content(
            %r{<interserver_http_port>9009</interserver_http_port>},
          ).without_content(
            %r{<interserver_http_host>},
          ).with_content(
            %r{<listen_host>127.0.0.1</listen_host>},
          ).with_content(
            %r{<listen_host>::</listen_host>},
          ).with_content(
            %r{<max_connections>4096</max_connections>},
          ).with_content(
            %r{<keep_alive_timeout>3</keep_alive_timeout>},
          ).with_content(
            %r{<max_concurrent_queries>100</max_concurrent_queries>},
          ).with_content(
            %r{<uncompressed_cache_size>8589934592</uncompressed_cache_size>},
          ).with_content(
            %r{<path>/var/lib/clickhouse/</path>},
          ).with_content(
            %r{<tmp_path>/var/lib/clickhouse/tmp/</tmp_path>},
          ).with_content(
            %r{<user_files_path>/var/lib/clickhouse/user_files/</user_files_path>},
          ).with_content(
            %r{<users_config>users.xml</users_config>},
          ).with_content(
            %r{<default_profile>default</default_profile>},
          ).with_content(
            %r{<default_database>default</default_database>},
          ).without_content(
            %r{<timezone>},
          ).with_content(
            %r{<umask>027</umask>},
          ).with_content(
            %r{
            <remote_servers>
            \s+<test_shard_localhost>
            \s+<shard>
            \s+<replica>
            \s+<host>localhost</host>
            \s+<port>9000</port>
            \s+</replica>
            \s+</shard>
            \s+</test_shard_localhost>
            \s+<test_shard_localhost_secure>
            \s+<shard>
            \s+<replica>
            \s+<host>localhost</host>
            \s+<port>9000</port>
            \s+<secure>1</secure>
            \s+</replica>
            \s+</shard>
            \s+</test_shard_localhost_secure>
            \s+</remote_servers>
            }x,
          ).with_content(
            %r{<builtin_dictionaries_reload_interval>3600</builtin_dictionaries_reload_interval>},
          ).with_content(
            %r{<max_session_timeout>3600</max_session_timeout>},
          ).with_content(
            %r{<default_session_timeout>60</default_session_timeout>},
          ).with_content(
            %r{
            \s+<query_log>
            \s+<database>system</database>
            \s+<table>query_log</table>
            \s+<partition_by>toYYYYMM\(event_date\)</partition_by>
            \s+<flush_interval_milliseconds>7500</flush_interval_milliseconds>
            \s+</query_log>
            }x,
          ).without_content(
            %r{<part_log>},
          ).without_content(
            %r{<path_to_regions_hierarchy_file>},
          ).without_content(
            %r{<path_to_regions_names_files>},
          ).with_content(
            %r{<dictionaries_config>\*_dictionary.xml</dictionaries_config>},
          ).with_content(
            %r{<compression>\s+</compression>},
          ).with_content(
            %r{
            <distributed_ddl>
            \s+<path>/clickhouse/task_queue/ddl</path>
            \s+</distributed_ddl>
            }x,
          ).without_content(
            %r{<max_suspicious_broken_parts>},
          ).with_content(
            %r{<format_schema_path>/var/lib/clickhouse/format_schemas/</format_schema_path>},
          ).without_content(
            %r{<disable_internal_dns_cache>},
          )
        end
      end
      describe 'Change Defaults' do
        context 'conf_dir' do
          before(:each) { params.merge!(conf_dir: '/foo/bar') }
          it { is_expected.to compile }
          it { is_expected.to contain_file('/foo/bar/users.xml') }
          it { is_expected.to contain_file('/foo/bar/config.xml') }
        end
        context 'package' do
          before(:each) { params.merge!(package: 'foobar') }
          it { is_expected.to compile }
          it { is_expected.to contain_package('foobar') }
        end
        context 'default_password_sha256' do
          before(:each) { params.merge!(default_password_sha256: 'DEADBEEF') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/users.xml',
            ).with_ensure('file').with_content(
              %r{
              <users>
              \s+<default>
              \s+<password_sha256_hex>DEADBEEF</password_sha256_hex>
              }x,
            )
          end
        end
        context 'max_memory_usage' do
          before(:each) { params.merge!(max_memory_usage: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/users.xml',
            ).with_ensure('file').with_content(
              %r{<max_memory_usage>42</max_memory_usage>},
            )
          end
        end
        context 'use_uncompressed_cache' do
          before(:each) { params.merge!(use_uncompressed_cache: true) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/users.xml',
            ).with_ensure('file').with_content(
              %r{<use_uncompressed_cache>1</use_uncompressed_cache>},
            )
          end
        end
        context 'load_balancing' do
          before(:each) { params.merge!(load_balancing: 'nearest_hostname') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/users.xml',
            ).with_ensure('file').with_content(
              %r{<load_balancing>nearest_hostname</load_balancing>},
            )
          end
        end
        context 'log_level' do
          before(:each) { params.merge!(log_level: 'notice') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<level>notice</level>},
            )
          end
        end
        context 'log_file' do
          before(:each) { params.merge!(log_file: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<log>/foo/bar</log>},
            )
          end
        end
        context 'errorlog_file' do
          before(:each) { params.merge!(errorlog_file: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<errorlog>/foo/bar</errorlog>},
            )
          end
        end
        context 'log_rotate_size' do
          before(:each) { params.merge!(log_rotate_size: '42M') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<size>42M</size>},
            )
          end
        end
        context 'log_rotate_count' do
          before(:each) { params.merge!(log_rotate_count: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<count>42</count>},
            )
          end
        end
        context 'display_name' do
          before(:each) { params.merge!(display_name: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<display_name>foobar</display_name>},
            )
          end
        end
        context 'http_port' do
          before(:each) { params.merge!(http_port: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<http_port>42</http_port>},
            )
          end
        end
        context 'tcp_port' do
          before(:each) { params.merge!(tcp_port: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<tcp_port>42</tcp_port>},
            )
          end
        end
        context 'https_port' do
          before(:each) { params.merge!(https_port: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<https_port>42</https_port>},
            )
          end
        end
        context 'tcp_secure_port' do
          before(:each) { params.merge!(tcp_secure_port: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<tcp_secure_port>42</tcp_secure_port>},
            )
          end
        end
        context 'certificate_file' do
          before(:each) { params.merge!(certificate_file: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<server>.+<certificateFile>/foo/bar</certificateFile>.+</server>}m,
            )
          end
        end
        context 'private_key_file' do
          before(:each) { params.merge!(private_key_file: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<server>.+<privateKeyFile>/foo/bar</privateKeyFile>.+</server>}m,
            )
          end
        end
        context 'dh_params_file' do
          before(:each) { params.merge!(dh_params_file: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<server>.+<dhParamsFile>/foo/bar</dhParamsFile>.+</server>}m,
            )
          end
        end
        context 'verification_mode' do
          before(:each) { params.merge!(verification_mode: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<server>.+<verificationMode>foobar</verificationMode>.+</server>}m,
            )
          end
        end
        context 'load_default_ca_file' do
          before(:each) { params.merge!(load_default_ca_file: false) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<server>.+<loadDefaultCAFile>false</loadDefaultCAFile>.+</server>}m,
            ).with_content(
              %r{<client>.+<loadDefaultCAFile>false</loadDefaultCAFile>.+</client>}m,
            )
          end
        end
        context 'cache_dessions' do
          before(:each) { params.merge!(cache_sessions: false) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<server>.+<cacheSessions>false</cacheSessions>.+</server>}m,
            ).with_content(
              %r{<client>.+<cacheSessions>false</cacheSessions>.+</client>}m,
            )
          end
        end
        context 'disable_protocols' do
          before(:each) { params.merge!(disable_protocols: ['tls', 'sslv2']) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<server>.+<disableProtocols>tls,sslv2</disableProtocols>.+</server>}m,
            ).with_content(
              %r{<client>.+<disableProtocols>tls,sslv2</disableProtocols>.+</client>}m,
            )
          end
        end
        context 'prefer_server_ciphers' do
          before(:each) { params.merge!(prefer_server_ciphers: false) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<server>.+<preferServerCiphers>false</preferServerCiphers>.+</server>}m,
            ).with_content(
              %r{<client>.+<preferServerCiphers>false</preferServerCiphers>.+</client>}m,
            )
          end
        end
        context 'allow_self_signed_client' do
          before(:each) { params.merge!(allow_self_signed_client: true) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <verificationMode>none</verificationMode>
              \s+<invalidCertificateHandler>
              \s+<name>AcceptCertificateHandler</name>
              \s+</invalidCertificateHandler>
              }x,
            )
          end
        end
        context 'interserver_http_port' do
          before(:each) { params.merge!(interserver_http_port: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<interserver_http_port>42</interserver_http_port>},
            )
          end
        end
        context 'interserver_http_host' do
          before(:each) { params.merge!(interserver_http_host: 'foo.bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<interserver_http_host>foo.bar</interserver_http_host>},
            )
          end
        end
        context 'listen_hosts bind all' do
          before(:each) { params.merge!(listen_hosts: ['::']) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<listen_host>::</listen_host>},
            )
          end
        end
        context 'listen_hosts bind specific' do
          before(:each) do
            params.merge!(listen_hosts: ['192.0.2.42', '2001:db8::42'])
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<listen_host>192.0.2.42</listen_host>},
            ).with_content(
              %r{<listen_host>2001:db8::42</listen_host>},
            )
          end
        end
        context 'max_connections' do
          before(:each) { params.merge!(max_connections: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<max_connections>42</max_connections>},
            )
          end
        end
        context 'keep_alive_timeout' do
          before(:each) { params.merge!(keep_alive_timeout: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<keep_alive_timeout>42</keep_alive_timeout>},
            )
          end
        end
        context 'max_concurrent_queries' do
          before(:each) { params.merge!(max_concurrent_queries: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<max_concurrent_queries>42</max_concurrent_queries>},
            )
          end
        end
        context 'uncompressed_cache_size' do
          before(:each) { params.merge!(uncompressed_cache_size: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<uncompressed_cache_size>42</uncompressed_cache_size>},
            )
          end
        end
        context 'data_path' do
          before(:each) { params.merge!(data_path: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<path>/foo/bar/</path>},
            )
          end
        end
        context 'tmp_path' do
          before(:each) { params.merge!(tmp_path: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<tmp_path>/foo/bar/</tmp_path>},
            )
          end
        end
        context 'user_files_path' do
          before(:each) { params.merge!(user_files_path: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<user_files_path>/foo/bar/</user_files_path>},
            )
          end
        end
        context 'timezone' do
          before(:each) { params.merge!(timezone: 'UTC') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<timezone>UTC</timezone>},
            )
          end
        end
        context 'umask' do
          before(:each) { params.merge!(umask: '022') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<umask>022</umask>},
            )
          end
        end
        context 'remotes' do
          before(:each) do
            params.merge!(
              remotes: {
                'multi_shard' => [
                  {
                    'weight' => 1,
                    'replicas' => [
                      {
                        'host' => 'rep1.example.com',
                        'port' => 9001,
                      },
                      {
                        'host' => 'rep1.example.com',
                        'port' => 9002,
                      },
                    ],
                  },
                  {
                    'weight' => 2,
                    'internal_replication' => true,
                    'replicas' => [
                      {
                        'host' => 'rep2.example.com',
                        'port' => 9001,
                        'secure' => true,
                      },
                      {
                        'host' => 'rep3.example.com',
                        'port' => 9001,
                        'user' => 'username',
                        'password' => 'password',
                      },
                    ],
                  },
                ],
              },
            )
          end
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
                <remote_servers>
                \s+<multi_shard>
                \s+<shard>
                \s+<weight>1</weight>
                \s+<replica>
                \s+<host>rep1.example.com</host>
                \s+<port>9001</port>
                \s+</replica>
                \s+<replica>
                \s+<host>rep1.example.com</host>
                \s+<port>9002</port>
                \s+</replica>
                \s+</shard>
                \s+<shard>
                \s+<weight>2</weight>
                \s+<internal_replication>true</internal_replication>
                \s+<replica>
                \s+<host>rep2.example.com</host>
                \s+<port>9001</port>
                \s+<secure>1</secure>
                \s+</replica>
                \s+<replica>
                \s+<host>rep3.example.com</host>
                \s+<port>9001</port>
                \s+<user></user>
                \s+<password></password>
                \s+</replica>
                \s+</shard>
                \s+</multi_shard>
                \s+</remote_servers>
              }x,
            )
          end
        end
        context 'builtin_dictionaries_reload_interval' do
          before(:each) do
            params.merge!(builtin_dictionaries_reload_interval: 42)
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<builtin_dictionaries_reload_interval>42</builtin_dictionaries_reload_interval>},
            )
          end
        end
        context 'max_session_timeout' do
          before(:each) { params.merge!(max_session_timeout: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<max_session_timeout>42</max_session_timeout>},
            )
          end
        end
        context 'default_session_timeout' do
          before(:each) { params.merge!(default_session_timeout: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<default_session_timeout>42</default_session_timeout>},
            )
          end
        end
        context 'query_log_db' do
          before(:each) { params.merge!(query_log_db: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<query_log>.*<database>foobar</database>.*</query_log>}m,
            )
          end
        end
        context 'query_log_table' do
          before(:each) { params.merge!(query_log_table: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<query_log>.*<table>foobar</table>.*</query_log>}m,
            )
          end
        end
        context 'query_log_partition_by' do
          before(:each) { params.merge!(query_log_partition_by: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<query_log>.*<partition_by>foobar</partition_by>.*</query_log>}m,
            )
          end
        end
        context 'query_log_flush_interval' do
          before(:each) { params.merge!(query_log_flush_interval: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<query_log>.*<flush_interval_milliseconds>42</flush_interval_milliseconds>.*</query_log>}m,
            )
          end
        end
        context 'part_log_enable' do
          before(:each) { params.merge!(part_log_enable: true) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <part_log>
              \s+<database>system</database>
              \s+<table>part_log</table>
              \s+<flush_interval_milliseconds>7500</flush_interval_milliseconds>
              \s+</part_log>
              }x,
            )
          end
        end
        context 'part_log_db' do
          before(:each) do
            params.merge!(part_log_enable: true, part_log_db: 'foobar')
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <part_log>
              \s+<database>foobar</database>
              \s+<table>part_log</table>
              \s+<flush_interval_milliseconds>7500</flush_interval_milliseconds>
              \s+</part_log>
              }x,
            )
          end
        end
        context 'part_log_table' do
          before(:each) do
            params.merge!(part_log_enable: true, part_log_table: 'foobar')
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <part_log>
              \s+<database>system</database>
              \s+<table>foobar</table>
              \s+<flush_interval_milliseconds>7500</flush_interval_milliseconds>
              \s+</part_log>
              }x,
            )
          end
        end
        context 'part_log_flush_interval' do
          before(:each) do
            params.merge!(part_log_enable: true, part_log_flush_interval: 42)
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <part_log>
              \s+<database>system</database>
              \s+<table>part_log</table>
              \s+<flush_interval_milliseconds>42</flush_interval_milliseconds>
              \s+</part_log>
              }x,
            )
          end
        end
        context 'path_to_regions_hierarchy_file' do
          before(:each) do
            params.merge!(path_to_regions_hierarchy_file: '/foo/bar')
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<path_to_regions_hierarchy_file>/foo/bar</path_to_regions_hierarchy_file>},
            )
          end
        end
        context 'path_to_regions_names_files' do
          before(:each) { params.merge!(path_to_regions_names_files: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<path_to_regions_names_files>/foo/bar</path_to_regions_names_files>},
            )
          end
        end
        context 'dictionaries_config' do
          before(:each) { params.merge!(dictionaries_config: '*_foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<dictionaries_config>\*_foobar</dictionaries_config>},
            )
          end
        end
        context 'compression_enable' do
          before(:each) { params.merge!(compression_enable: true) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <compression>
              \s+<case>
              \s+<min_part_size>10000000000</min_part_size>
              \s+<min_part_size_ratio>0.01</min_part_size_ratio>
              \s+<method>zstd</method>
              \s+<level>6</level>
              \s+</case>
              \s+</compression>
              }x,
            )
          end
        end
        context 'compression_min_part_size' do
          before(:each) do
            params.merge!(
              compression_enable: true,
              compression_min_part_size: 42,
            )
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <compression>
              \s+<case>
              \s+<min_part_size>42</min_part_size>
              \s+<min_part_size_ratio>0.01</min_part_size_ratio>
              \s+<method>zstd</method>
              \s+<level>6</level>
              \s+</case>
              \s+</compression>
              }x,
            )
          end
        end
        context 'compression_min_part_size_ratio' do
          before(:each) do
            params.merge!(
              compression_enable: true,
              compression_min_part_size_ratio: 0.2,
            )
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <compression>
              \s+<case>
              \s+<min_part_size>10000000000</min_part_size>
              \s+<min_part_size_ratio>0.2</min_part_size_ratio>
              \s+<method>zstd</method>
              \s+<level>6</level>
              \s+</case>
              \s+</compression>
              }x,
            )
          end
        end
        context 'compression_method' do
          before(:each) do
            params.merge!(
              compression_enable: true,
              compression_method: 'foobar',
            )
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <compression>
              \s+<case>
              \s+<min_part_size>10000000000</min_part_size>
              \s+<min_part_size_ratio>0.01</min_part_size_ratio>
              \s+<method>foobar</method>
              \s+<level>6</level>
              \s+</case>
              \s+</compression>
              }x,
            )
          end
        end
        context 'compression_level' do
          before(:each) do
            params.merge!(
              compression_enable: true,
              compression_level: 4,
            )
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <compression>
              \s+<case>
              \s+<min_part_size>10000000000</min_part_size>
              \s+<min_part_size_ratio>0.01</min_part_size_ratio>
              \s+<method>zstd</method>
              \s+<level>4</level>
              \s+</case>
              \s+</compression>
              }x,
            )
          end
        end
        context 'distributed_ddl_enable' do
          before(:each) { params.merge!(distributed_ddl_enable: true) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <distributed_ddl>
              \s+<path>/clickhouse/task_queue/ddl</path>
              \s+</distributed_ddl>
              }x,
            )
          end
        end
        context 'distributed_ddl_path' do
          before(:each) do
            params.merge!(
              distributed_ddl_enable: true,
              distributed_ddl_path: '/foo/bar',
            )
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <distributed_ddl>
              \s+<path>/foo/bar</path>
              \s+</distributed_ddl>
              }x,
            )
          end
        end
        context 'distributed_ddl_profile' do
          before(:each) do
            params.merge!(
              distributed_ddl_enable: true,
              distributed_ddl_profile: 'foobar',
            )
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <distributed_ddl>
              \s+<path>/clickhouse/task_queue/ddl</path>
              \s+<profile>foobar</profile>
              \s+</distributed_ddl>
              }x,
            )
          end
        end
        context 'max_suspicious_broken_parts' do
          before(:each) { params.merge!(max_suspicious_broken_parts: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{
              <merge_tree>
              \s+<max_suspicious_broken_parts>42</max_suspicious_broken_parts>
              \s+</merge_tree>
              }x,
            )
          end
        end
        context 'max_table_size_to_drop' do
          before(:each) { params.merge!(max_table_size_to_drop: 42) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<max_table_size_to_drop>42</max_table_size_to_drop>},
            )
          end
        end
        context 'format_schema_path' do
          before(:each) { params.merge!(format_schema_path: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<format_schema_path>/foo/bar/</format_schema_path>},
            )
          end
        end
        context 'disable_internal_dns_cache' do
          before(:each) { params.merge!(disable_internal_dns_cache: true) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/config.xml',
            ).with_ensure('file').with_content(
              %r{<disable_internal_dns_cache>1</disable_internal_dns_cache>},
            )
          end
        end
        context 'users' do
          before(:each) do
            params.merge!(
              users: {
                'foo' => {
                  'password' => 'bar',
                  'networks' => ['::/0'],
                },
                'bar' => {
                  'password' => 'foo',
                  'networks' => ['2001:db8::/48', '192.0.2.0/24'],
                  'profile' => 'foobar',
                  'quota' => 'foobar',
                },
              },
            )
          end
          it { is_expected.to compile }
          it do
            is_expected.to contain_file(
              '/etc/clickhouse-server/users.xml',
            ).with_ensure('file').with_content(
              %r{
              <foo>
              \s+<password>bar</password>
              \s+<networks>
              \s+<ip>::/0</ip>
              \s+</networks>
              \s+<profile>default</profile>
              \s+<quota>default</quota>
              \s+</foo>
              }x,
            ).with_content(
              %r{
              <bar>
              \s+<password>foo</password>
              \s+<networks>
              \s+<ip>2001:db8::/48</ip>
              \s+<ip>192\.0\.2\.0/24</ip>
              \s+</networks>
              \s+<profile>foobar</profile>
              \s+<quota>foobar</quota>
              \s+</bar>
              }x,
            )
          end
        end
      end
      describe 'check bad type' do
        context 'conf_dir' do
          before(:each) { params.merge!(conf_dir: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'package' do
          before(:each) { params.merge!(package: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'password_sha256' do
          before(:each) { params.merge!(password_sha256: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'max_memory_usage' do
          before(:each) { params.merge!(max_memory_usage: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'use_uncompressed_cache' do
          before(:each) { params.merge!(use_uncompressed_cache: 'foobar') }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'load_balancing' do
          before(:each) { params.merge!(load_balancing: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'log_level' do
          before(:each) { params.merge!(log_level: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'log_file' do
          before(:each) { params.merge!(log_file: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'errorlog_file' do
          before(:each) { params.merge!(errorlog_file: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'log_rotate_size' do
          before(:each) { params.merge!(log_rotate_size: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'log_rotate_count' do
          before(:each) { params.merge!(log_rotate_count: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'display_name' do
          before(:each) { params.merge!(display_name: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'http_port' do
          before(:each) { params.merge!(http_port: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'tcp_port' do
          before(:each) { params.merge!(tcp_port: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'https_port' do
          before(:each) { params.merge!(https_port: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'tcp_secure_port' do
          before(:each) { params.merge!(tcp_secure_port: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'certificate_file' do
          before(:each) { params.merge!(certificate_file: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'private_key_file' do
          before(:each) { params.merge!(private_key_file: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'dh_params_file' do
          before(:each) { params.merge!(dh_params_file: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'verification_mode' do
          before(:each) { params.merge!(verification_mode: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'load_default_ca_file' do
          before(:each) { params.merge!(load_default_ca_file: 'foobar') }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'cache_dessions' do
          before(:each) { params.merge!(cache_sessions: 'foobar') }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'disable_protocols' do
          before(:each) { params.merge!(disable_protocols: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'prefer_server_ciphers' do
          before(:each) { params.merge!(prefer_server_ciphers: 'foobar') }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'allow_self_signed_client' do
          before(:each) { params.merge!(allow_self_signed_client: 'foobar') }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'interserver_http_port' do
          before(:each) { params.merge!(interserver_http_port: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'interserver_http_host' do
          before(:each) { params.merge!(interserver_http_host: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'listen_hosts' do
          before(:each) { params.merge!(listen_hosts: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'max_connections' do
          before(:each) { params.merge!(max_connections: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'keep_alive_timeout' do
          before(:each) { params.merge!(keep_alive_timeout: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'max_concurrent_queries' do
          before(:each) { params.merge!(max_concurrent_queries: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'uncompressed_cache_size' do
          before(:each) { params.merge!(uncompressed_cache_size: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'data_path' do
          before(:each) { params.merge!(data_path: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'tmp_path' do
          before(:each) { params.merge!(tmp_path: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'user_files_path' do
          before(:each) { params.merge!(user_files_path: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'timezone' do
          before(:each) { params.merge!(timezone: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'umask' do
          before(:each) { params.merge!(umask: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'remotes' do
          before(:each) { params.merge!(remotes: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'builtin_dictionaries_reload_interval' do
          before(:each) { params.merge!(builtin_dictionaries_reload_interval: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'max_session_timeout' do
          before(:each) { params.merge!(max_session_timeout: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'default_session_timeout' do
          before(:each) { params.merge!(default_session_timeout: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'query_log_db' do
          before(:each) { params.merge!(query_log_db: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'query_log_table' do
          before(:each) { params.merge!(query_log_table: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'query_log_partition_by' do
          before(:each) { params.merge!(query_log_partition_by: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'query_log_flush_interval' do
          before(:each) { params.merge!(query_log_flush_interval: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'part_log_enable' do
          before(:each) { params.merge!(part_log_enable: 'foobar') }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'part_log_db' do
          before(:each) { params.merge!(part_log_db: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'part_log_table' do
          before(:each) { params.merge!(part_log_table: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'part_log_flush_interval' do
          before(:each) { params.merge!(part_log_flush_interval: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'path_to_regions_hierarchy_file' do
          before(:each) { params.merge!(path_to_regions_hierarchy_file: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'path_to_regions_names_files' do
          before(:each) { params.merge!(path_to_regions_names_files: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'dictionaries_config' do
          before(:each) { params.merge!(dictionaries_config: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'dictionaries_config_source' do
          before(:each) { params.merge!(dictionaries_config_source: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'compression_enable' do
          before(:each) { params.merge!(compression_enable: 'foobar') }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'compression_min_part_size' do
          before(:each) { params.merge!(compression_min_part_size: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'compression_min_part_size_ration' do
          before(:each) { params.merge!(compression_min_part_size_ration: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'compression_method' do
          before(:each) { params.merge!(compression_method: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'compression_level' do
          before(:each) { params.merge!(compression_level: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'distributed_ddl_enable' do
          before(:each) { params.merge!(distributed_ddl_enable: 'foobar') }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'distributed_ddl_path' do
          before(:each) { params.merge!(distributed_ddl_path: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'distributed_ddl_profile' do
          before(:each) { params.merge!(distributed_ddl_profile: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'max_suspicious_broken_parts' do
          before(:each) { params.merge!(max_suspicious_broken_parts: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'max_table_size_to_drop' do
          before(:each) { params.merge!(max_table_size_to_drop: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'format_schema_path' do
          before(:each) { params.merge!(format_schema_path: true) }
          it { is_expected.to raise_error(Puppet::Error) }
        end
        context 'disable_internal_dns_cache' do
          before(:each) { params.merge!(disable_internal_dns_cache: 'foobar') }
          it { is_expected.to raise_error(Puppet::Error) }
        end
      end
    end
  end
end
