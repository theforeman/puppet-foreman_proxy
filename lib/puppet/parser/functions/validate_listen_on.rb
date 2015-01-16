module Puppet::Parser::Functions
  newfunction(:validate_listen_on, :doc => <<-'EOF'
Validate whether a Foreman Smart Proxy feature is configured for http, https or both
EOF
) do |args|

    valid_values = ['http', 'https', 'both']

    unless args.length > 0 then
      raise Puppet::ParseError, ("validate_listen_on(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    args.each do |arg|
      candidates = args

      unless arg.is_a?(Array) then
        candidates = Array.new(1,arg)
      end

      candidates.each do |value|
        unless valid_values.include? value
          raise Puppet::ParseError, ("#{value.inspect} is not a valid value.  Valid values are: #{valid_values.map(&:to_s).uniq.join(", ")}")
        end
      end
    end
  end
end
