# TODO: Move this to its own file
Puppet::Functions.create_function(:'foreman_proxy::generate_uuid') do
  dispatch :uuid do
    # no arguments
  end

  def uuid
    SecureRandom.uuid
  end
end
