require 'base64'

module CloudFrontSigning
  class UrlSafeEncodedParam
    def self.url_safe(s)
      s.gsub('+','-').gsub('=','_').gsub('/','~').gsub(/[\n ]/,'')
    end

    attr_reader :input

    def initialize(input)
      @input = input
    end

    def to_s
      encoded
    end

    private

    def encoded
      @encoded ||= self.class.url_safe(Base64.encode64(input))
    end
  end
end
