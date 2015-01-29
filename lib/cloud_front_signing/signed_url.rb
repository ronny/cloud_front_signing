require 'pp'
require 'addressable/uri'

require 'cloud_front_signing/url_safe_encoded_param'
require 'cloud_front_signing/policy'

module CloudFrontSigning
  POLICY_OPTION_KEYS = [:starting, :ending, :resource, :ip_range].freeze

  class SignedUrl
    attr_reader :unsigned_url, :options

    def initialize(unsigned_url, options)
      @unsigned_url = unsigned_url
      @options = options
    end

    def to_s
      uri.to_s
    end

    private

    def uri
      @uri ||= Addressable::URI.parse(unsigned_url).tap do |u|
        params = {
          'Signature'     => signature,
          'Key-Pair-Id'   => key_pair_id,
        }
        unless policy.canned?
          # shorter URL if canned (no need to include the encoded policy)
          params['Policy'] = encoded_policy
        end
        u.query_values = (u.query_values || {}).merge(params)
      end
    end

    def encoded_policy
      @encoded_policy ||= UrlSafeEncodedParam.new(policy.to_s).to_s
    end

    def policy
      @policy ||= Policy.new(policy_options)
    end

    def signed_policy
      @signed_policy ||= key.sign(OpenSSL::Digest::SHA1.new, policy.to_s)
    end

    def signature
      @signature ||= UrlSafeEncodedParam.new(signed_policy).to_s
    end

    def key_pair_id
      options[:key_pair_id]
    end

    def key
      options[:key]
    end

    def policy_options
      @policy_options ||= begin
        initial = {resource: unsigned_url}
        options.reduce(initial) do |hash, (k, v)|
          hash[k] = v if POLICY_OPTION_KEYS.include?(k)
          hash
        end
      end
    end
  end
end

