# frozen_string_literal: true

require 'spec_helper'

# NOTE: To test, install mongoDB and clone this nodejs/express project: https://github.com/clockworkpc/building-restful-apis

RSpec.describe Cpc::Api::MyRestfulApi do
  context 'Node and Express on Port 4000', online: true do
    url = 'http://localhost'
    port = 4000
    subject = Cpc::Api::MyRestfulApi.new(url, port)

    contact_hsh = {
      christianName: 'John',
      surname: 'Doe',
      email: 'johndoe@test.com',
      company: 'Foo Bar Pty Ltd',
      phone: 123_456_789
    }

    it 'should get root page' do
      res = subject.get_root
      expect(res.code).to eq(200)
      expect(res.body).to eq('Node and Express server running on port 4000')
      expect(res.headers['x-powered-by']).to eq('Express')
    end

    it 'should POST a new contact' do
      res = subject.post_contact(contact_hsh)
      expect(res.code).to eq(200)
      expect(res.body['_id'].length).to eq(24)
      expect(res.body['christianName']).to eq(contact_hsh[:christianName])
      expect(res.body['surname']).to eq(contact_hsh[:surname])
      expect(res.body['email']).to eq(contact_hsh[:email])
      expect(res.body['company']).to eq(contact_hsh[:company])
      expect(res.body['phone']).to eq(contact_hsh[:phone])
      expect(res.headers['x-powered-by']).to eq('Express')
      puts res.body['_id']
    end

    it 'should GET all contacts' do
      puts "@new_contact_id = #{@new_contact_id}"
      res = subject.get_all_contacts
      contact_key_ary = %w[_id christianName surname email company phone created_date __v]
      body_key_ary_ary = res.body.map(&:keys)
      irregular_entries = body_key_ary_ary.reject { |ary| ary == contact_key_ary }
      expect(res.code).to eq(200)
      expect(irregular_entries).to be_empty
    end

    it 'should GET a Contact by ID' do
      id_str = '5e1fd536e2f0747c7c67a949'
      res = subject.get_contact(id_str)
      expect(res.code).to eq(200)
      expect(res.body['_id'].length).to eq(24)
      expect(res.body['christianName']).to eq(contact_hsh[:christianName])
      expect(res.body['surname']).to eq(contact_hsh[:surname])
      expect(res.body['email']).to eq(contact_hsh[:email])
      expect(res.body['company']).to eq(contact_hsh[:company])
      expect(res.body['phone']).to eq(contact_hsh[:phone])
      expect(res.headers['x-powered-by']).to eq('Express')
    end

    it 'should PUT a contact by ID' do
      id_str = '5e1fda38e2f0747c7c67a952'

      put1_contact_hsh = {
        _id: id_str,
        christianName: 'John',
        surname: 'Doe',
        email: 'johndoe@test.com',
        company: 'Foo Bar Pty Ltd',
        phone: 123_456_789
      }


      put2_contact_hsh = {
        _id: id_str,
        christianName: 'Hamish',
        surname: 'MacDonald',
        email: 'hamishmacdonald@test.com',
        company: 'Bar Foo Pty Ltd',
        phone: 987_654_321
      }

      res1 = subject.put_contact(put1_contact_hsh)
      expect(res1.code).to eq(200)
      expect(res1.body['_id'].length).to eq(24)
      expect(res1.body['christianName']).to eq(put1_contact_hsh[:christianName])
      expect(res1.body['surname']).to eq(put1_contact_hsh[:surname])
      expect(res1.body['email']).to eq(put1_contact_hsh[:email])
      expect(res1.body['company']).to eq(put1_contact_hsh[:company])
      expect(res1.body['phone']).to eq(put1_contact_hsh[:phone])
      expect(res1.headers['x-powered-by']).to eq('Express')

      res1.body.each {|k,v| puts "#{k}: #{v}"}

      res2 = subject.put_contact(put2_contact_hsh)
      expect(res2.code).to eq(200)
      expect(res2.body['_id'].length).to eq(24)
      expect(res2.body['christianName']).to eq(put2_contact_hsh[:christianName])
      expect(res2.body['surname']).to eq(put2_contact_hsh[:surname])
      expect(res2.body['email']).to eq(put2_contact_hsh[:email])
      expect(res2.body['company']).to eq(put2_contact_hsh[:company])
      expect(res2.body['phone']).to eq(put2_contact_hsh[:phone])
      expect(res2.headers['x-powered-by']).to eq('Express')

      res2.body.each {|k,v| puts "#{k}: #{v}"}
    end

    it 'should DELETE the latest_contact contact' do
      protected_id_ary = ['5e1fd536e2f0747c7c67a949', '5e1fda38e2f0747c7c67a952']

      all_contacts = subject.get_all_contacts.body
      deletable_contacts = all_contacts.reject { |h| protected_id_ary.include?(h['_id']) }
      deletable_ids = deletable_contacts.map { |h| h['_id'] }
      expect(deletable_ids.count).to eq(all_contacts.count - 2)
      id_to_delete = deletable_ids.last

      res = subject.delete_latest_contact(protected_id_ary)
      expect(res.code).to eq(200)
      expect(res.body["id"]).to eq(id_to_delete)
    end
  end
end
