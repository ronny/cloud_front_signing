require 'time'
require 'yajl'

module CloudFrontSigning
  class Policy
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def canned?
      options.keys == [:ending] || options.keys.sort == [:ending, :resource]
    end

    def object
      @object ||= {
        "Statement" => [
          {
            "Resource" => resource,
            "Condition" => conditions,
          }
        ]
      }
    end

    def to_s
      Yajl.dump(object, pretty: false, indent: '')
    end

    private

    def conditions
      @conditions ||= begin
        result = {
          "DateLessThan" => {"AWS:EpochTime" => ending},
        }

        if options[:starting]
          result["DateGreaterThan"] = {"AWS:EpochTime" => starting}
        end

        # CIDR notation, e.g. 127.1.2.0/24
        if options[:ip_range]
          result["IpAddress"] = {"AWS:SourceIp" => options[:ip_range]}
        end

        result
      end
    end

    def starting
      @starting ||= epoch_time(options[:starting])
    end

    def ending
      @ending ||= begin
        raise ArgumentError, 'missing :ending option' unless options[:ending]
        epoch_time(options[:ending])
      end
    end

    def resource
      @resource ||= options[:resource] or raise ArgumentError, 'missing :resource option'
    end

    def epoch_time(timelike)
      case timelike
      when String then Time.parse(timelike).to_i
      when Time   then timelike.to_i
      else raise ArgumentError.new("Invalid argument #{timelike} - String or Time required - #{timelike.class} passed.")
      end
    end
  end
end

