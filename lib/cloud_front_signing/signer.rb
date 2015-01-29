require 'openssl'

require "cloud_front_signing/signed_url"

module CloudFrontSigning
  class Signer
    attr_reader :private_key_string, :key_pair_id

    def initialize(private_key_string, key_pair_id)
      @private_key_string = private_key_string
      @key_pair_id = key_pair_id
    end

    def sign(unsigned_url, options = {})
      url_options = options.merge(
        key_pair_id: key_pair_id,
        key: key,
      )
      SignedUrl.new(unsigned_url, url_options).to_s
    end

    private

    def key
      @key ||= OpenSSL::PKey::RSA.new(private_key_string)
    end
  end
end

