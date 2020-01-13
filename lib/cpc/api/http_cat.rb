require_relative '../util/api_util'
require 'base64'

module Cpc
  module Api
    class HttpCat
      include Cpc::Util::ApiUtil

      attr_reader :host

      def initialize(host_url = nil)
        @host = host_url.nil? ? 'https://http.cat' : host_url
        @cat_dir = 'spec/output/http_cats'
      end

      def save_http_cat(res_body, code_int)
        filename = "#{code_int.to_s}.jpg"
        path = [@cat_dir, filename].join('/')
        f = File.open(path, 'w+')
        f.write(res_body)
        f.close
        path
      end

      def get_status_code(code_int)
        args_hsh = { url: { host: @host, path: code_int } }
        res = api_get_request(args_hsh, 'ASCII-8BIT')
        binding.pry
        save_http_cat(res.body, code_int)
      end

      def get_status_code_100
        get_status_code(100)
      end

      def get_status_code_101
        get_status_code(101)
      end

      def get_status_code_200
        get_status_code(200)
      end

      def get_status_code_201
        get_status_code(201)
      end

      def get_status_code_202
        get_status_code(202)
      end

      def get_status_code_204
        get_status_code(204)
      end

      def get_status_code_206
        get_status_code(206)
      end

      def get_status_code_207
        get_status_code(207)
      end

      def get_status_code_300
        get_status_code(300)
      end

      def get_status_code_301
        get_status_code(301)
      end

      def get_status_code_302
        get_status_code(302)
      end

      def get_status_code_303
        get_status_code(303)
      end

      def get_status_code_304
        get_status_code(304)
      end

      def get_status_code_305
        get_status_code(305)
      end

      def get_status_code_307
        get_status_code(307)
      end

      def get_status_code_400
        get_status_code(400)
      end

      def get_status_code_401
        get_status_code(401)
      end

      def get_status_code_402
        get_status_code(402)
      end

      def get_status_code_403
        get_status_code(403)
      end

      def get_status_code_404
        get_status_code(404)
      end

      def get_status_code_405
        get_status_code(405)
      end

      def get_status_code_406
        get_status_code(406)
      end

      def get_status_code_408
        get_status_code(408)
      end

      def get_status_code_409
        get_status_code(409)
      end

      def get_status_code_410
        get_status_code(410)
      end

      def get_status_code_411
        get_status_code(411)
      end

      def get_status_code_412
        get_status_code(412)
      end

      def get_status_code_413
        get_status_code(413)
      end

      def get_status_code_414
        get_status_code(414)
      end

      def get_status_code_415
        get_status_code(415)
      end

      def get_status_code_416
        get_status_code(416)
      end

      def get_status_code_417
        get_status_code(417)
      end

      def get_status_code_418
        get_status_code(418)
      end

      def get_status_code_420
        get_status_code(420)
      end

      def get_status_code_421
        get_status_code(421)
      end

      def get_status_code_422
        get_status_code(422)
      end

      def get_status_code_423
        get_status_code(423)
      end

      def get_status_code_424
        get_status_code(424)
      end

      def get_status_code_425
        get_status_code(425)
      end

      def get_status_code_426
        get_status_code(426)
      end

      def get_status_code_429
        get_status_code(429)
      end

      def get_status_code_431
        get_status_code(431)
      end

      def get_status_code_444
        get_status_code(444)
      end

      def get_status_code_450
        get_status_code(450)
      end

      def get_status_code_451
        get_status_code(451)
      end

      def get_status_code_499
        get_status_code(499)
      end

      def get_status_code_500
        get_status_code(500)
      end

      def get_status_code_501
        get_status_code(501)
      end

      def get_status_code_502
        get_status_code(502)
      end

      def get_status_code_503
        get_status_code(503)
      end

      def get_status_code_504
        get_status_code(504)
      end

      def get_status_code_506
        get_status_code(506)
      end

      def get_status_code_507
        get_status_code(507)
      end

      def get_status_code_508
        get_status_code(508)
      end

      def get_status_code_509
        get_status_code(509)
      end

      def get_status_code_510
        get_status_code(510)
      end

      def get_status_code_511
        get_status_code(511)
      end

      def get_status_code_599
        get_status_code(599)
      end
    end
  end
end
