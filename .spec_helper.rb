require 'serverspec'
require 'docker'
require 'yaml'
require 'active_support'
require 'active_support/core_ext'

default = YAML.load_file("Projects/#{ ENV['TEST_PROJECT'] }/properties/default.yml").to_h
test_case = YAML.load_file(ENV['TEST_CASE_FILE']).to_h
test_case = default.deep_merge!(test_case)
if test_case['container'] != nil
  env = test_case['container']['env'] || {}
else
  env = {}
end
if test_case['container'] != nil
  create_options = test_case['container']['create_options']
else
  create_options = nil
end

set :backend, :docker
set :docker_url, ENV["DOCKER_HOST"]
set :docker_image, ENV['TEST_IMAGE']
set :env, env
set :docker_container_create_options, create_options

if test_case != false
  set_property test_case
else
  set_property ({}) 
end

if ENV['DOCKER_TLS_VERIFY'] != 0 && ENV['DOCKER_TLS_VERIFY'] != nil
  if ENV["DOCKER_CERT_PATH"] != nil
    Docker.options = {
        client_cert: File.join(ENV["DOCKER_CERT_PATH"], 'cert.pem'),
        client_key: File.join(ENV["DOCKER_CERT_PATH"], 'key.pem'),
        ssl_ca_file: File.join(ENV["DOCKER_CERT_PATH"], 'ca.pem'),
        scheme: 'https'
    }
  else
    Docker.options = {
        client_cert: File.join(ENV["HOME"], '.docker/cert.pem'),
        client_key: File.join(ENV["HOME"], '.docker/key.pem'),
        ssl_ca_file: File.join(ENV["HOME"], '.docker/ca.pem'),
        scheme: 'https'
    }
  end
end

