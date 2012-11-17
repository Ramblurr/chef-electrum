default['electrum']['electrum_user'] = 'electrum'
default['electrum']['bitcoin_user'] = 'bitcoin'
default['electrum']['prefix'] = '/usr/local/'
default['electrum']['certs_path'] = '/etc/ssl/electrum'

default['electrum']['bitcoin_force'] = false
default['electrum']['bitcoin_tag'] = 'f4112f87f95c6b5e406612906a7904adf1b4df34'

#bitcoin.conf settings
default['electrum']['bitcoin']['daemon'] = '1'

# electrum.conf settings
default['electrum']['conf']['server']['host'] = "hostname"
default['electrum']['conf']['server']['native_port'] = "50000"
default['electrum']['conf']['server']['stratum_tcp_port'] = "50001"
default['electrum']['conf']['server']['stratum_http_port'] = "8081"
default['electrum']['conf']['server']['password'] = "ireallyshouldchangethis"
default['electrum']['conf']['server']['banner'] = "Welcome to Electrum Server!"
default['electrum']['conf']['server']['irc'] = "no"
default['electrum']['conf']['server']['cache'] = "yes"
default['electrum']['conf']['server']['ssl_certfile'] = ""
default['electrum']['conf']['server']['ssl_keyfile'] = ""
default['electrum']['conf']['server']['backend'] = "bitcoind"
default['electrum']['conf']['bitcoind']['host'] = "localhost"
default['electrum']['conf']['bitcoind']['port'] = "8332"
default['electrum']['conf']['bitcoind']['user'] = "rpcuser"
default['electrum']['conf']['bitcoind']['password'] = "rpcpass"
