# STATUS

Use http://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CloudFront/UrlSigner.html instead. I don't plan to maintain this gem any more.

# CloudFrontSigning

Sign [AWS CloudFront] URLs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloud_front_signing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloud_front_signing

## Usage

```
# Replace these for your specific AWS account/CloudFront configuration
private_key_string = IO.read("path/to/pk-123456789012.pem")
key_pair_id = "123456789012"

signer = CloudFrontSigning::Signer.new(private_key_string, key_pair_id)

unsigned_url = "https://distribution-id.cloudfront.net/private.zip"
options = {ending: 1.hour.from_now} # or, e.g. `Time.now + 3600` if you don't have activesupport
signed_url = signer.sign(unsigned_url, options)
```

Valid options:

- `ending`: required, the signed URL will only be accessible until this time, a `Time` object or a `String` parseable by `Time.parse`
- `resource`: the base URL including your query strings, if any, but excluding the CloudFront Policy, Signature, and Key-Pair-Id parameters, uses unsigned_url by default
- `starting`: the signed URL will only be accessible after this time, a `Time` object or a `String` parseable by `Time.parse`
- `ip_range`: the signed URL will only be accessible by IP addresses in this range, a CIDR string, e.g. `10.1.2.3/32`, `10.2.3.0/24`, and so on.

Specifying `starting` and/or `ip_range` will cause the signed URL to include a [custom policy] which is longer.

## Credits

Code adapted from https://github.com/dylanvaughn/aws_cf_signer by Dylan Vaughn.

Parts of signing code taken from a question on Stack Overflow asked by Ben Wiseley, and answered by Blaz Lipuscek and Manual M:

http://stackoverflow.com/questions/2632457/create-signed-urls-for-cloudfront-with-ruby
http://stackoverflow.com/users/315829/ben-wiseley
http://stackoverflow.com/users/267804/blaz-lipuscek
http://stackoverflow.com/users/327914/manuel-m

## References

[AWS documentation on private content and signed URLs]

[AWS CloudFront]: http://aws.amazon.com/cloudfront/
[custom policy]: http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-creating-signed-url-custom-policy.html
[AWS documentation on private content and signed URLs]: http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-signed-urls-overview.html

## License

MIT. See LICENSE.txt.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cloud_front_signing/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
