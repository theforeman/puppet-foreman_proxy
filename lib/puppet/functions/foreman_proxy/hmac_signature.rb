Puppet::Functions.create_function(:'foreman_proxy::hmac_signature') do
  dispatch :sign do
    required_param 'String', :key
    required_param 'String', :value
  end

  def sign(key, value)
    OpenSSL::HMAC.hexdigest('SHA512', key, value)
  end
end
