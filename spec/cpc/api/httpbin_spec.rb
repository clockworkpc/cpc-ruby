# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Api::Httpbin do
  include Cpc::Util::CollectionUtil
  include Cpc::Util::StringUtil

  let(:response_headers_foobar) do
    {
      code: 200,
      body: {
        content_length: '93',
        content_type: 'application/json',
        freeform: 'foobar'
      }
    }
  end

  let(:deflate_res) do
    {
      code: 200,
      body: {
        "deflated": true,
        "headers": {
          "accept": 'application/json',
          "accept_encoding": 'gzip, deflate',
          "accept_language": 'en-GB,en-US;q=0.9,en;q=0.8',
          "connection": 'keep-alive',
          "host": '0.0.0.0',
          "referer": 'http://0.0.0.0/',
          "user_agent": 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.74 Safari/537.36'
        },
        "method": 'GET',
        "origin": '172.17.0.1'
      }
    }
  end

  let(:deny_res) do
    {
      code: 200,
      body: File.read('spec/fixtures/httpbin/denied_response.html')
    }
  end

  let(:unicode_body) { File.read('spec/fixtures/httpbin/unicode.html') }

  let(:gzip_body) do
    {
      "gzipped": true,
      "headers": {
        "accept": 'application/json',
        "accept_encoding": 'gzip, deflate',
        "accept_language": 'en-US,en;q=0.9,lt;q=0.8',
        "connection": 'keep-alive',
        "host": '0.0.0.0',
        "referer": 'http://0.0.0.0/',
        "user_agent": 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/72.0.3626.121 Chrome/72.0.3626.121 Safari/537.36'
      },
      "method": 'GET',
      "origin": '172.17.0.1'
    }
  end

  let(:html_body) { File.read('spec/fixtures/httpbin/html.html') }

  let(:json_body) do
    {
      "slideshow" => {
        "author" => 'Yours Truly',
        "date"=> 'date of publication',
        "slides" => [
          {
            "title" => 'Wake up to WonderWidgets!',
            "type" => 'all'
          },
          {
            "items" => [
              'Why <em>WonderWidgets</em> are great',
              'Who <em>buys</em> WonderWidgets'
            ],
            "title" => 'Overview',
            "type" => 'all'
          }
        ],
        "title" => 'Sample Slide Show'
      }
    }
  end

  let(:robots_body) do
    <<~HEREDOC
    User-agent: *
    Disallow: /deny
    HEREDOC
  end

  let(:xml_body) { File.read('spec/fixtures/httpbin/xml_body.xml') }

  let(:pizza_form) do
    {
      "comments": "Keep it fresh!",
      "custemail": "test@test.com",
      "custname": "Foo Bar",
      "custtel": "0412345678",
      "delivery": "11:45",
      "size": "medium",
      "topping": [
        "bacon",
        "cheese",
        "onion",
        "mushroom"
      ]
    }
   end


  context 'Running locally in Docker, if docker installed, otherwise online', online: true do

    before(:all) do
      @port = 80
      apt = `apt-cache policy docker`
      snap = `snap list | grep docker`
      docker_installed = apt.match?(/Installed: \d+\.\d+.*/) || snap.match?(/docker\s+\d+\.\d+\.\d+\s+\d+\s+\w+\s+\w+/)
      docker_running = `docker ps -q`.strip
      @container_id = docker_running

      case
      when docker_installed && docker_running.match?(/[a-zA-Z0-9]+/)
        puts Rainbow("Docker running").green
        url = "http://0.0.0.0:#{@port}"
      when docker_installed && docker_running.empty?
        puts Rainbow("Docker not running").red
        url = "http://0.0.0.0:#{@port}"
        system("docker run -p #{@port}:#{@port} kennethreitz/httpbin </dev/null &>/dev/null &")


        running = true
        while running
          counter = 0.0
          container_id = `docker ps -q`.strip

          unless container_id.empty?
            status = `docker inspect #{container_id} --format '{{.State.Status}}'`.strip
            args = `docker inspect #{container_id} --format '{{.Args}}'`.split
            container_url = args[1]
            port = container_url.split(':')[1] unless container_url.nil?
            homepage_curl = `curl 0.0.0.0:#{@port}`

            puts "Container ID: #{container_id}"
            puts "Status: #{status}"
            puts "Port: #{port}"

            docker_running = status.match?('running') && port.to_i == @port
            homepage_loaded = html?(homepage_curl)

            if docker_running && homepage_loaded
              puts "Everything looks good..."
              sleep 1
              @container_id = container_id
              break
            end
          end


          counter += 1
          puts "Waited for #{counter} seconds"
          sleep 1
        end
      else
        url = 'https://httpbin.org'
      end

      @subject = Cpc::Api::Httpbin.new(url)
    end

    # after(:all) do
    #   puts Rainbow("Stopping Docker Container: #{@container_id}").yellow
    #   puts `docker stop #{@container_id}`
    # end

    context 'naked requests' do
      it 'should send a GET request' do
        res = @subject.naked_get
        expect(res.code).to eq(200)
      end

      it 'should send a POST request' do
        res = @subject.naked_post
        expect(res.code).to eq(200)
      end

      it 'should send a PATCH request' do
        res = @subject.naked_patch
        expect(res.code).to eq(200)
      end

      it 'should send a PUT request' do
        res = @subject.naked_put
        expect(res.code).to eq(200)
      end

      it 'should send a DELETE request' do
        res = @subject.naked_delete
        expect(res.code).to eq(200)
      end
    end

    context 'auth requests' do
      it 'should send a basic-auth request ' do
        res = @subject.basic_auth('foo', 'bar')
        expect(res.code).to eq(401)
      end

      it 'should send an authorization token request' do
        res = @subject.bearer('auth123')
        expect(res.code).to eq(401)
      end
    end

    context 'request inspection' do
      it 'should return incoming http headers' do
        res = @subject.request_headers
        expect(res.code).to eq(200)
        expect(res.body['headers']['Accept']).to eq('*/*')
        expect(res.body['headers']['Accept-Encoding']).to eq('gzip;q=1.0,deflate;q=0.6,identity;q=0.3')
        expect(res.body['headers']['Host']).to eq('0.0.0.0')
        expect(res.body['headers']['User-Agent']).to eq('Ruby')
      end

      it 'should return IP address' do
        res = @subject.request_ip
        expect(res.code).to eq(200)
        expect(res.body['origin']).to eq('172.17.0.1')
      end
    end

    context 'response inspection' do
      it 'should get response-headers' do
        res = @subject.response_headers('foobar')
        expect(res.code).to eq(response_headers_foobar[:code])
        expect(res.body["Content-Length"]).to eq(response_headers_foobar[:body][:content_length])
        expect(res.body["Content-Type"]).to eq(response_headers_foobar[:body][:content_type])
        expect(res.body["freeform"]).to eq(response_headers_foobar[:body][:freeform])
      end

      it 'should post response-headers' do
        res = @subject.post_response_headers('foobar')
        expect(res.code).to eq(response_headers_foobar[:code])
        expect(res.body["Content-Length"]).to eq(response_headers_foobar[:body][:content_length])
        expect(res.body["Content-Type"]).to eq(response_headers_foobar[:body][:content_type])
        expect(res.body["freeform"]).to eq(response_headers_foobar[:body][:freeform])
      end
    end

    it 'should get Deflate-encoded data' do
      res = @subject.get_deflate_data
      expect(res.code).to eq(200)
      expect(res.body["deflated"]).to eq(true)
      expect(res.body["headers"]["Accept"]).to eq('*/*')
      expect(res.body["headers"]["Accept-Encoding"]).to eq('gzip;q=1.0,deflate;q=0.6,identity;q=0.3')
    end

    it 'should get Deny response' do
      res = @subject.get_deny
      expect(res.code).to eq(deny_res[:code])
      expect(res.body).to eq(deny_res[:body])
      expect(res.headers['content-type']).to eq('text/plain')
    end

    it 'should return utf-8 encoded data' do
      res = @subject.get_utf8
      body_diff_ary = []
      res_body_ary = res.body.split("\n")
      uni_body_ary = unicode_body.split("\n")
      res_body_ary.each_with_index { |l, i| body_diff_ary << (l == uni_body_ary[i]) }
      body_diff_ary.uniq!

      expect(res.code).to eq(200)
      expect(body_diff_ary.count).to eq(1)
      expect(body_diff_ary.first).to eq(true)
    end

    it 'should return gzip encoded data' do
      res = @subject.get_gzip
      expect(res.code).to eq(200)
      expect(res.body["gzipped"]).to eq(true)
    end

    it 'should return an html page' do
      res = @subject.get_html
      res_text = res.body.xpath("//p").text.strip
      let_text = Nokogiri::HTML(html_body).xpath("//p").text.strip

      expect(res.code).to eq(200)
      expect(res_text.eql?(let_text)).to eq(true)
    end

    it 'should return a JSON page' do
      res = @subject.get_json
      expect(res.code).to eq(200)
      expect(res.body).to eq(json_body)
    end

    it 'should return a robots.txt' do
      res = @subject.get_robots_txt
      expect(res.code).to eq(200)
      expect(res.body).to eq(robots_body)
    end

    it 'should return an XML document' do
      res = @subject.get_xml
      let_text = Nokogiri::XML(xml_body)
      res_slideshow = res.body.xpath("//slideshow").children.map {|c| [c.name.strip, c.text.strip] }
      let_slideshow = let_text.xpath("//slideshow").children.map {|c| [c.name.strip, c.text.strip] }

      expect(res.code).to eq(200)
      expect(res_slideshow).to eq(let_slideshow)
    end

    it 'should return base64 decoded string' do
      res = @subject.get_base64('Hello, World!')
      expect(res.code).to eq(200)
      expect(res.body).to eq('Hello, World!')
    end

    it 'should return a uuid' do
      res = @subject.get_uuid
      expect(res.code).to eq(200)
      expect(@subject.uuid?(res.body['uuid'])).to eq(true)
    end

    it 'should return empty cookies' do
      res = @subject.get_empty_cookies
      expect(res.code).to eq(200)
      expect(res.body['cookies'].empty?).to eq(true)
    end

    it 'should return empty cookies list after delete' do
      # TODO: https://stackoverflow.com/questions/6934185/ruby-net-http-following-redirects
      res = @subject.delete_cookie('helloworld')
      expect(res.code).to eq(200)
      expect(res.body['cookies'].empty?).to eq(true)
    end

    it 'should post a pizza order' do
      res = @subject.post_pizza_order(pizza_form)
      expect(res.code).to eq(200)
      expect(res.body["form"]["comments"]).to eq(pizza_form[:comments])
      expect(res.body["form"]["comments"]).to eq(pizza_form[:comments])
      expect(res.body["form"]["custemail"]).to eq(pizza_form[:custemail])
      expect(res.body["form"]["custname"]).to eq(pizza_form[:custname])
      expect(res.body["form"]["custtel"]).to eq(pizza_form[:custtel])
      expect(res.body["form"]["delivery"]).to eq(pizza_form[:delivery])
      expect(res.body["form"]["size"]).to eq(pizza_form[:size])
      expect(res.body["form"]["topping"]).to eq(pizza_form[:topping])
    end
  end
end
