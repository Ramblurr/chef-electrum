default['electrum']['user'] = 'bitcoin'
default['electrum']['prefix'] = '/usr/local/'

default['electrum']['bootstrap'] = false
default['electrum']['bootstrap_url'] = 'http://eu2.bitcoincharts.com/blockchain/bootstrap.dat'
default['electrum']['bootstrap_sha256'] = 'a3f258e7af030165360596e4cb0b9beb24b4ce97352c22e65349b89ad5fc5d3e'

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
default['electrum']['conf']['leveldb']['path'] = "/var/db/leveldb"
default['electrum']['conf']['bitcoind']['host'] = "localhost"
default['electrum']['conf']['bitcoind']['port'] = "8332"
default['electrum']['conf']['bitcoind']['user'] = "rpcuser"
default['electrum']['conf']['bitcoind']['password'] = "rpcpass"
