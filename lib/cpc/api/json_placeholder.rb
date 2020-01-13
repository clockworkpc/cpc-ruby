require_relative '../util/api_util'

module Cpc
  module Api
    class JsonPlaceholder
      include Cpc::Util::ApiUtil

      attr_reader :host

      def initialize(host_url)
        @host = host_url
      end

      def default_host
        'https://jsonplaceholder.typicode.com'
      end

      def get_all_posts
        args_hsh = { url: { host: @host, path: 'posts' } }
        api_get_request(args_hsh)
      end

      def get_post_by_id(id_int)
        args_hsh = { url: { host: @host, path: 'posts', id: id_int } }
        api_get_request(args_hsh)
      end

      def get_posts_by_userId(userId_int)
        args_hsh = {
          url: { host: @host, path: 'posts' },
          url_params: { "userId" => userId_int }
        }
        api_get_request(args_hsh)
      end

      def get_posts_by_title(title_str)
        post_hsh_ary = get_all_posts
        post_hsh_ary.body.select { |post_hsh| post_hsh['title'].eql?(title_str) }
      end

      def get_posts_by_body(body_str)
        post_hsh_ary = get_all_posts
        post_hsh_ary.body.select { |post_hsh| post_hsh['body'].eql?(body_str) }
      end

      def get_comments_by_postId(postId_int)
        args_hsh = {
          url: { host: @host, path: 'comments' },
          url_params: { "postId" => postId_int }
        }
        api_get_request(args_hsh)
      end

      def get_comment_by_id(id_int)
        args_hsh = {
          url: { host: @host, path: 'comments' },
          url_params: { "id" => id_int }
        }
        api_get_request(args_hsh)
      end

      def post_jp_post(hsh)
        args_hsh = {
          url: { host: @host, path: 'posts' },
          request_headers: { "Content-type" => "application/json; charset=UTF-8" },
          request_body: hsh
        }
        api_post_request(args_hsh)
      end

      def update_jp_post(hsh)
        args_hsh = {
          url: { host: @host, path: 'posts', postId: hsh[:id] },
          request_headers: { "Content-type" => "application/json; charset=UTF-8" },
          request_body: hsh
        }
        api_put_request(args_hsh)
      end

      def patch_jp_post_title(postId_int, title_str)
        args_hsh = {
          url: { host: @host, path: 'posts', postId: postId_int },
          request_headers: { "Content-type" => "application/json; charset=UTF-8" },
          request_body: { 'title' => title_str }
        }
        api_patch_request(args_hsh)
      end

      def delete_jp_post_by_postId(postId_int)
        args_hsh = { url: { host: @host, path: 'posts', postId: postId_int } }
        api_delete_request(args_hsh)
      end

      def get_all_albums
        args_hsh = { url: { host: @host, path: 'albums' } }
        api_get_request(args_hsh)
      end

      def get_photos_by_album(albumId_int)
        args_hsh = {
          url: { host: @host, path: 'photos' },
          url_params: { 'albumId' => albumId_int }
        }
        api_get_request(args_hsh)
      end

      def get_all_todos
        args_hsh = { url: { host: @host, path: 'todos' } }
        api_get_request(args_hsh)
      end

      def get_todos_by_user(userId_int)
        args_hsh = {
          url: { host: @host, path: 'todos' },
          url_params: { 'userId' => userId_int }
        }
        api_get_request(args_hsh)
      end

      def get_todos_by_user_by_completion(userId_int, completed_bool)
        todo_hsh_ary = get_todos_by_user(userId_int).body
        todo_hsh_ary.select { |todo_hsh| todo_hsh['completed'] == completed_bool }
      end

      def get_completed_todos_by_user(userId_int)
        get_todos_by_user_by_completion(userId_int, true)
      end

      def get_incomplete_todos_by_user(userId_int)
        get_todos_by_user_by_completion(userId_int, false)
      end
    end
  end
end
