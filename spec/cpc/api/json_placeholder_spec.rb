require 'spec_helper'

RSpec.describe Cpc::Api::JsonPlaceholder do

  let(:all_posts) { JSON.parse(File.read('spec/fixtures/json_placeholder/posts.json')) }

  let(:all_albums) { JSON.parse(File.read('spec/fixtures/json_placeholder/albums.json')) }

  let(:all_todos) { JSON.parse(File.read('spec/fixtures/json_placeholder/todos.json')) }

  let(:comment_90) do
  {
    "postId" => 18,
    "id" => 90,
    "name" => "eum voluptas dolores molestias odio amet repellendus",
    "email" => "Sandy.Erdman@sabina.info",
    "body" => "vitae cupiditate excepturi eum veniam laudantium aspernatur blanditiis\naspernatur quia ut assumenda et magni enim magnam\nin voluptate tempora\nnon qui voluptatem reprehenderit porro qui voluptatibus"
  }
  end

  let(:jp_post_hsh) do
    {
      title: 'Hello World',
      body: 'Welcome to JSON Placeholder, you are a champion.',
      userId: 42
    }
  end

  let(:jp_post_update_hsh) do
    {
      id: 42,
      title: 'Hello World',
      body: 'Welcome to JSON Placeholder, you are a champion.',
      userId: 69
    }
  end

  let(:album_5_photos) { JSON.parse(File.read('spec/fixtures/json_placeholder/album_5_photos.json')) }

  let(:user_5_todos) { JSON.parse(File.read('spec/fixtures/json_placeholder/user_5_todos.json')) }

  context 'JSON Placeholder on localhost, if json-server installed', online: true do

    before(:all) do
      # @port = 3333
      # lsof_cmd = `lsof -t -i:#{@port}`
      # original_db_dir = [Dir.home, 'Development', 'study', 'jsonplaceholder'].join('/')
      # original_db_path = [original_db_dir, 'data.json'].join('/')
      # db_dir = [Dir.home, 'Development', 'study', 'json-server'].join('/')
      # db_path = [db_dir, 'db.json'].join('/')
      # db = File.exists?(db_path)
      # npm_cmd = `npm list -g | grep "json-server"`
      # npm = npm_cmd.match?(/json-server@\d+\.\d+\.\d+/)
      # @refresh_db = system("cp -v #{original_db_path} #{db_path}")
      #
      # case
      # when lsof_cmd.match?(/\d+/)
      #   url = "http://localhost:#{@port}"
      # when db && npm
      #   url = "http://localhost:#{@port}"
      #   system("cd #{db_dir} && json-server --watch #{db_path} --port #{@port} </dev/null &>/dev/null &")
      # else
        url = 'https://jsonplaceholder.typicode.com'
      # end

      @subject = Cpc::Api::JsonPlaceholder.new(url)

      # running = true
      # while running
      #   counter = 0.0
      #   break if `lsof -t -i:#{@port}`.match?(/\d+/)
      #   counter += 0.5
      #   puts "Waited for #{counter} seconds"
      #   sleep 0.5
      # end
    end

    after(:all) do
      # `kill -9 $(lsof -t -i:#{@port})`
      # @refresh_db
    end

    context 'Json Placeholder Posts and Comments' do
      context 'GET posts' do
        it 'should get all posts' do
          res = @subject.get_all_posts
          expect(res.body.count).to eq(all_posts.count)
          expect(res.body[99]).to eq(all_posts[99])
          expect(res.body[99]["userId"]).to eq(all_posts[99]["userId"])
          expect(res.body[99]["id"]).to eq(all_posts[99]["id"])
          expect(res.body[99]["title"]).to eq('at nam consequatur ea labore ea harum')
        end

        it 'should get a post by post ID' do
          res = @subject.get_post_by_id(10)
          expect(res.code).to eq(200)
          expect(res.body['userId']).to eq(all_posts[9]['userId'])
          expect(res.body['id']).to eq(all_posts[9]['id'])
          expect(res.body['title']).to eq(all_posts[9]['title'])
          expect(res.body['body']).to eq(all_posts[9]['body'])
        end

        it 'should get post by userId' do
          res = @subject.get_posts_by_userId(10)
          expect(res.code).to eq(200)
          expect(res.body.count).to eq(10)
          expect(res.body.first['userId']).to eq(all_posts[90]['userId'])
          expect(res.body.first['id']).to eq(all_posts[90]['id'])
          expect(res.body.first['title']).to eq(all_posts[90]['title'])
          expect(res.body.first['body']).to eq(all_posts[90]['body'])
        end

        it 'should get posts by title' do
          res = @subject.get_posts_by_title('ad iusto omnis odit dolor voluptatibus')
          expect(res.first['userId']).to eq(all_posts[89]['userId'])
          expect(res.first['id']).to eq(all_posts[89]['id'])
          expect(res.first['title']).to eq(all_posts[89]['title'])
          expect(res.first['body']).to eq(all_posts[89]['body'])
        end

        it 'should get posts by body' do
          res = @subject.get_posts_by_body("minus omnis soluta quia\nqui sed adipisci voluptates illum ipsam voluptatem\neligendi officia ut in\neos soluta similique molestias praesentium blanditiis")
          expect(res.first['userId']).to eq(all_posts[89]['userId'])
          expect(res.first['id']).to eq(all_posts[89]['id'])
          expect(res.first['title']).to eq(all_posts[89]['title'])
          expect(res.first['body']).to eq(all_posts[89]['body'])
        end

        it 'should get comments by postId' do
          res = @subject.get_comments_by_postId(10)
          expect(res.code).to eq(200)
          expect(res.body.count).to eq(5)
          expect(res.body[2]["id"]).to eq(48)
          expect(res.body[2]["name"]).to eq("consequatur animi dolorem saepe repellendus ut quo aut tenetur")
          expect(res.body[2]["email"]).to eq("Manuela_Stehr@chelsie.tv")
          expect(res.body[2]["body"]).to eq("illum et alias quidem magni voluptatum\nab soluta ea qui saepe corrupti hic et\ncum repellat esse\nest sint vel veritatis officia consequuntur cum")
        end

        it 'should get comment by ID' do
          res = @subject.get_comment_by_id(90)
          expect(res.code).to eq(200)
          expect(res.body.first['id']).to eq(comment_90['id'])
          expect(res.body.first['postId']).to eq(comment_90['postId'])
          expect(res.body.first['title']).to eq(comment_90['title'])
          expect(res.body.first['body']).to eq(comment_90['body'])
        end
      end

      context 'POST requests' do
        it 'should create a post' do
          res = @subject.post_jp_post(jp_post_hsh)
          expect(res.code).to eq(201)
          expect(res.body['userId']).to eq(jp_post_hsh[:userId])
          expect(res.body['title']).to eq(jp_post_hsh[:title])
          expect(res.body['body']).to eq(jp_post_hsh[:body])
          expect(res.body['id']).to eq(101)
        end

      end

      context 'PUT requests' do
        it 'should update a post' do
          res = @subject.update_jp_post(jp_post_update_hsh)
          expect(res.code).to eq(200)
          expect(res.body['userId']).to eq(jp_post_update_hsh[:userId])
          expect(res.body['title']).to eq(jp_post_update_hsh[:title])
          expect(res.body['body']).to eq(jp_post_update_hsh[:body])
          expect(res.body['id']).to eq(jp_post_update_hsh[:id])
        end
      end

      context 'PATCH requests' do
        it 'should PATCH a JP post Title' do
          res = @subject.patch_jp_post_title(90, 'Hello, World!')
          expect(res.code).to eq(200)
          expect(res.body['title']).to eq('Hello, World!')
          expect(res.body['userId']).to eq(all_posts[89]['userId'])
          expect(res.body['id']).to eq(all_posts[89]['id'])
          expect(res.body['body']).to eq(all_posts[89]['body'])
        end
      end

      context 'DELETE requests' do
        it 'should DELETE a JP post' do
          res = @subject.delete_jp_post_by_postId(90)
          expect(res.code).to eq(200)
          expect(res.body).to be_empty
        end
      end
    end

    context 'Json Placeholder Albums and Photos' do
      # subject = Cpc::Api::JsonPlaceholder.new

      it 'should retrieve all albums' do
        res = @subject.get_all_albums
        expect(res.code).to eq(200)
        expect(res.body.count).to eq(all_albums.count)
        expect(res.body[4]['userId']).to eq(all_albums[4]['userId'])
        expect(res.body[4]['id']).to eq(all_albums[4]['id'])
        expect(res.body[4]['title']).to eq(all_albums[4]['title'])
      end

      it 'should retrieve photos by album' do
        res = @subject.get_photos_by_album(5)
        expect(res.code).to eq(200)
        expect(res.body.count).to eq(album_5_photos.count)
        expect(res.body[5]['albumId']).to eq(album_5_photos[5]['albumId'])
        expect(res.body[5]['id']).to eq(album_5_photos[5]['id'])
        expect(res.body[5]['title']).to eq(album_5_photos[5]['title'])
        expect(res.body[5]['url']).to eq(album_5_photos[5]['url'])
        expect(res.body[5]['thumbnailUrl']).to eq(album_5_photos[5]['thumbnailUrl'])
      end

    end

    context 'Json Placeholder Todos' do
      # subject = Cpc::Api::JsonPlaceholder.new

      it 'should retrieve all Todos' do
        res = @subject.get_all_todos
        expect(res.code).to eq(200)
        expect(res.body.count).to eq(all_todos.count)
        expect(res.body[4]['userId']).to eq(all_todos[4]['userId'])
        expect(res.body[4]['id']).to eq(all_todos[4]['id'])
        expect(res.body[4]['title']).to eq(all_todos[4]['title'])
        expect(res.body[4]['completed']).to eq(all_todos[4]['completed'])
      end

      it 'should retrieve Todo by user' do
        res = @subject.get_todos_by_user(5)
        expect(res.code).to eq(200)
        expect(res.body.count).to eq(user_5_todos.count)
        expect(res.body[5]['userId']).to eq(user_5_todos[5]['userId'])
        expect(res.body[5]['id']).to eq(user_5_todos[5]['id'])
        expect(res.body[5]['title']).to eq(user_5_todos[5]['title'])
        expect(res.body[5]['completed']).to eq(user_5_todos[5]['completed'])
      end

      it 'should get all completed Todos for a user' do
        res = @subject.get_completed_todos_by_user(5)
        expect(res.count).to eq(12)
        expect(res.select {|t| t['completed'] == true }.count).to eq(12)
        expect(res.reject {|t| t['completed'] == true }.count).to eq(0)
        expect(res[4]['userId']).to eq(5)
        expect(res[4]['id']).to eq(87)
        expect(res[4]['title']).to eq("laudantium quae eligendi consequatur quia et vero autem")
      end

      it 'should get all incomplete Todos for a user' do
        res = @subject.get_incomplete_todos_by_user(5)
        expect(res.count).to eq(8)
        expect(res.select {|t| t['completed'] == true }.count).to eq(0)
        expect(res.reject {|t| t['completed'] == true }.count).to eq(8)
        expect(res[4]['userId']).to eq(5)
        expect(res[4]['id']).to eq(96)
        expect(res[4]['title']).to eq("nobis suscipit ducimus enim asperiores voluptas")
      end
    end
  end


end
