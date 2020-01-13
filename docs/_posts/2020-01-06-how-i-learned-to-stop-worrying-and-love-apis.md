---
layout: post
title: "How I Learned To Stop Worrying And Love APIs"
author: Alexander Garber
date: 2020-01-06 06:30:00 +1000
tags: [walkthrough, api]
---

## Time To Crack the API Walnut

Comprehending what an API is in theory is quite easy for anyone who understands how to write shell scripts or code at the most basic level, but understanding how to make API calls to a variety of endpoints and parse the responses takes time and effort.  I already had a practical understanding of simple GET requests, but I decided over the Christmas break to master the fundamentals of APIs.

My learning-by-doing approach was as follows:
1. Create a wrapper Module for Ruby's `http/net` called `ApiUtil`.
2. Write unit tests in RSpec for a variety of public, open API endpoints.
3. Continually refine and extend `ApiUtil` until it could reliably work with all the endpoints.

To this end, I cut my teeth on [JSON Placeholder](https://jsonplaceholder.typicode.com),
then refined my base driver code on [Httpbin](https://httpbin.org),
then toyed with a selection of endpoints from [HTTPCat](https://http.cat)
then finished with the most recognisable [Bit.ly](https://app.bitly.com/bbt2/) endpoints for shortening a link and expanding a bitlink.

By the end of my project, I had a tidy API wrapper method `ApiUtil#api_request` which does the following:
1. Accept as parameters all the information needed to make the appropriate API call to a given endpoint.
2. Create and send an API request object, e.g. `Net::HTTP::GET` or `Net::HTTP::POST`
3. Receive the response as an `HTTP::OK` object (if successful).
4. Return the parsed response as a `Cpc::Util::ApiResponse` class instance.

## Why Not Just Use An Existing Library?

At work, where time is of the essence, I would have spent the equivalent time in familiarising myself with a third-party library, but seeing as all the gems out there are wrappers for `net/http`, and I was on holiday, I could afford to advance my learning by working directly with pure API calls and API responses.

## ApiUtil#api_request

```ruby
module Cpc
  module Util
    module ApiUtil
      def api_request(type_str, args_hsh, encoding_str)
      end
    end
  end
end
```

This method takes three parameters:
1. `type_str` => the type of request, e.g. GET or POST, as a String.
2. `args_hsh` => URL, request headers, and request body, all packaged into a Hash.  (Nested key-value pairs)
3. `encoding_str` => Encoding to apply to the response body, as a String.

The method then constructs the request:
* Converts the URL into a URI,
* Determines whether to use SSL,
* Creates a new request object -- GET, POST, etc.
* Adds request headers, if any included,
* Adds the request body, if any included,

The method then sends the request and receives the response from the server:
* If the response is **302** (Redirect), a subsequent API call is constructed and sent to the redirect endpoint.
* If the response is not **302**, the response

The final `HTTP::OK` object is passed to a instance of my custom Class `Cpc::Util::ApiResponse`, which parses the response object and makes available as readable attributes the API response code, response body, and response headers:

```ruby
module Cpc
  module Util
    class ApiResponse
      include Cpc::Util::StringUtil
      include Cpc::Util::CollectionUtil

      attr_reader :code, :body, :headers

      def initialize(res_obj, encoding_str)
        @res = res_obj
        @code = res_obj.code.to_i
        @body = parse_response_body(encoding_str)
        @headers = collect_headers
      end

      def parse_response_body(encoding_str)
        # Parses @res.body as JSON, HTML, XML, or simply returns as is.
        # Forces encoding if conditions are met
      end

      def collect_headers
        headers_hsh = Hash.new
        @res.to_hash.each { |k, v| headers_hsh[k] = v.first }
        headers_hsh
      end
    end
  end
end
```

This light-weight object is more comfortable to work with than a simple Hash, and includes a couple of methods for nested information which it would not be worthwhile to add as readable attributes:

```ruby
def temporary_headers
  @body['headers']
end

def method
  @body['method']
end

def origin
  @body['origin']
end

```

Thus `res`, an initialized Class instance, would have the following
* `res.code` => the API response code, converted to an integer.
* `res.body` => key-value pairs, image, text, etc.
* `res.headers` => usually key-value pairs.

In most cases, the response body is UTF-8-encoded String, but the method `#parse_response_body` allows for others such as Base64 for images.
The response body is returned either as a String or it parsed:
* If valid JSON, then `JSON#parse` returns a JSON object.
* If valid HTML, then `Nokogiri::HTML` returns an HTML object.
* If valid XML, then `Nokogiri::XML` return an XML object.
* Else, the response body is returned as it is.  (If an image is expected, the method that invokes `ApiUtil#api_request` can save the body to an image file, e.g. JPG or PNG)

## API Classes

At the time of writing, there are four Classes in the Module `Cpc::Api` that utilise `ApiUtil`:
- [JsonPlaceholder](https://jsonplaceholder.typicode.com)
- [Httpbin](https://httpbin.org)
- [HttpCat](https://http.cat)
- [Bitly](https://app.bitly.com/bbt2/)

In each class, there is an instance method for every API endpoint. Because `ApiUtil#api_request` takes care of the entire API call from request to response, all that is required to invoke it are the following parameters:
- URL
- Request headers
- Request body

These parameters are bundled into a Hash -- `args_hsh` -- which is the most important parameter of the `ApiUtil#api_request` method.  To make `api_request` a little easier to work with, each type of API call has its own wrapper method:
- `api_get_request` => `api_request('get', args_hsh, encoding)`
- `api_post_request` => `api_request('post', args_hsh, encoding)`
- `api_put_request` => `api_request('put', args_hsh, encoding)`
- `api_delete_request` => `api_request('delete', args_hsh, encoding)`
- `api_patch_request` => `api_request('patch', args_hsh, encoding)`

Thus, any method that invokes `api_request` is constructed as follows:
1. Declare a Hash that contains at least the URL.
2. Pass the Hash, and encoding if required, to the appropriate `api_request` method.

At the end of the process `ApiUtil#api_request` instantiates and returns a `Cpc::Util::ApiResponse` object, which has the following instance variables:
- `@code`
- `@body`
- `@headers`

## Example: Naked GET Request

[Httpbin](https://httpbin.org) provides an endpoint for a simple GET request with neither headers nor a body: https://httpbin.org/get

The Class `Cpc::Api::Httpbin` initializes with an instance variable `@host`:

```ruby
def initialize(host_url)
  if host_url.nil?
    @host = 'https://httpbin.org'
  else
    @host = host_url
  end
end
```

Thus, a method to hit the GET endpoint:

```ruby
def naked_get
  args_hsh = { url: { host: @host, path: 'get' } }
  api_get_request(args_hsh)
end
```

`ApiUtil#api_get_request` joins the values of the nested Hash `{ host: @host, path: 'get' }` into a URL String and then passes that String to `URI#parse`; the URI is added to a new GET request; and ultimately, `api_request` returns a `Cpc::Util::ApiResponse` object:

```ruby
@body=
  {"args"=>{},
   "headers"=>{"Accept"=>"*/*", "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Connection"=>"close", "Host"=>"0.0.0.0", "User-Agent"=>"Ruby"},
   "origin"=>"172.17.0.1",
   "url"=>"http://0.0.0.0/get"},
 @code=200,
 @headers=
  {"server"=>"gunicorn/19.9.0",
   "date"=>"Tue, 07 Jan 2020 21:19:32 GMT",
   "connection"=>"close",
   "content-type"=>"application/json",
   "content-length"=>"263",
   "access-control-allow-origin"=>"*",
   "access-control-allow-credentials"=>"true"}
```

## Example: POST with URL Parameters

```ruby
def post_response_headers(str)
  args_hsh = {
    url: { host: @host, path: 'response-headers' },
    url_params: { "freeform": str }
  }
  api_post_request(args_hsh)
end
```

`ApiUtil#`
