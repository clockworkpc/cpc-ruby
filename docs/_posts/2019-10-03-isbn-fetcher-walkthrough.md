---
layout: post
title: "ISBN Fetcher Walkthrough"
author: Alexander Garber
date: 2019-10-03 17:36:00 +1000
tags: [walkthrough, isbn-fetcher]
---

This is a walkthrough for the "ISBN Fetcher" defined by the class `Cpc::Toolkit::IsbnFetcher`.

The story of this solution follows a process that should be familiar to anyone involved in Agile software development:

1. Discussion of requirements
2. Preparation of sample inputs
3. Feature specification with sample inputs and outputs
4. Behaviour-driven development
5. Test-driven development
6. Integration testing
7. End-to-end testing
8. Review and approval

## Background

My wife and I wanted an easy way to catalogue our books for sale, which would satisfy the following criteria:
1. The catalogue should be a complete record of our books.
2. That it should be as easy as possible to record an entry for each book.
3. That each record should also include the book's location, i.e. which box it is in.

This is the solution we came up with:
1. Use a USB bar-code scanner to scan each book's ISBN into a spreadsheet.
1. Retrieve the full details of the book -- title, author, etc. -- via the ISBN.
1. Save the full details of each book in a new spreadsheet.

### Manual Input

My wife scanned into a spreadsheet every book in the collection and manually added which box the scanned book was located in.  Thus, we started with a spreadsheet that started like this:

| ISBN          | BOX      |
|---------------|----------|
| 661741006715  | 01 Craft |
| 9780307587060 | 01 Craft |
| 9780615528540 | 01 Craft |

### Database

While my wife was doing her bit, I looked for a suitable ISBN database.  I eventually decided to pay for access to [ISBNdb](https://isbndb.com/), which, as the name suggests, is a large database for ISBNs, and more to the point, has very good API documentation.

## Development

At this point we had two important pieces of the puzzle:
1. Input data: A spreadsheet of ISBNs and box numbers.
2. Output data source: a database accessible via API.

It was now time to start work on putting together a software solution.

### Specification
The first step was to describe the feature in language that both my wife and I could understand, so I wrote a Cucumber feature file called `isbn_fetcher.feature`.

```markdown
@online_extra
Feature: ISBN Fetcher
  In order to put together a list of books for sale
  I want to fetch the details of books via their ISBNs from ISBNdb

  Scenario Outline: ISBN Numbers Provided
    Given the box title is "<box>"
    And I make an API call to "ISBNdb" with "<isbn>"
    And the API response code is "200"
    When I parse the API response body and write it to "ISBN CSV"
    Then I should have a copy of the response body in a CSV
    And in the API response the box title should be "<box>"
    And in the API response the long title of the book should be "<long_title>"
    And in the API response the the author of the book should be "<author>"
    And in the API response the the publisher of the book should be "<publisher>"
    And in the API response the the binding of the book should be "<binding>"
    And in the API response the the book should have "<pages>" pages
    And in the API response the the publication date of the book should be "<date_published>"

    Examples:
    | isbn          | box                 | long_title                                      | author        | publisher                                     | binding      | pages | date_published |
    | 9781931499651 | 01 Craft            | Knitting Vintage Socks                          | Nancy Bush    | Interweave                                    | Spiral-bound | 128   | 2005           |
    | 9781596688513 | 02 Craft            | Scottish Knits: Colorwork & Cables With A Twist | Martin Storey | Interweave                                    | Paperback    | 152   | 2013           |
    | 9780957740358 | 04 Children's Books | Eye_spy_who_am_i                                | N/A           | Melbourne : Borghesi & Adam Publishers, 2001. | N/A          | N/A   | N/A            |
```

### Step Definitions
Once we had described the desired behaviour of our feature, the next step was to write Cucumber Steps, which define Cucumber's handling of the inputs and the expectations.

The Cucumber Steps invoked are contained in two Step files, according to whether the Step is specific to the ISBN Fetcher or could be re-used in testing another feature:
* `features/step_definitions/api_steps.rb`
* `features/step_definitions/isbn_fetcher_steps.rb`

Thus, `api_steps.rb` covers these Steps, which would be part of any feature that makes API calls:

```
And I make an API call to "ISBNdb" with "<isbn>"
And the API response code is "200"
When I parse the API response body and write it to "ISBN CSV"
```

And the rest of the Steps, being specific to ISBN Fetcher, are defined in `isbn_fetcher_steps.rb`.

```
Then I should have a copy of the response body in a CSV
And in the API response the box title should be "<box>"
And in the API response the long title of the book should be "<long_title>"
And in the API response the the author of the book should be "<author>"
And in the API response the the publisher of the book should be "<publisher>"
And in the API response the the binding of the book should be "<binding>"
And in the API response the the book should have "<pages>" pages
And in the API response the the publication date of the book should be "<date_published>"
```

The most important Step, for the purposes of our story, is this:

```ruby
Given("I make an API call to {string} with {string}") do |string1, string2|
  case
  when string1 == "ISBNdb"
    isbn_str = string2
    isbn = Cpc::Toolkit::IsbnFetcher.new('ISBN_DB_API_KEY')
    @book_details_hsh = isbn.collect_book_details(isbn_str, @box_str)
  end
end
```

Because it asserts that everything in this feature test will hinge on the following:

1. A Class called `Cpc::Toolkit::IsbnFetcher`.
1. This Class will be initialized with an API key.
1. This class will contain an instance method called `book_details`.
1. The instance method `book_details` will return a Hash containing all the details of a given book, given an **ISBN** and a **box label**.  

### RSpecs

At this point, with an outline of where the code for my solution would be housed (`Cpc::Toolkit::IsbnFetcher`), what the pivotal method would be called (`book_details`), and the requisite inputs (API key, ISBN, box label), I was ready to start writing my unit tests in RSpec.

Naturally, the Spec file would be called `spec/cpc/toolkit/isbn_fetcher_spec.rb`, and it would start like this:

```ruby
require 'spec_helper'

RSpec.describe Cpc::Toolkit::IsbnFetcher do
end
```

And it would contain a `context` block like this:

```ruby
context 'Authorised API key', online_extra: true do
  subject = Cpc::Toolkit::IsbnFetcher.new('ISBN_DB_API_KEY')
  context 'ISBN 9781931499651' do
    isbn_str = '9781931499651'
    box_str = '01 Craft'

    before(:all) do
      @book_details = subject.collect_book_details(isbn_str, box_str)
    end

    ## A series of `it` blocks containing expectations
  end
end
```

#### API Key

However, before I could proceed, I needed to securely handle my API key.  Rails 5 makes it easy to store sensitive data in an encrypted credentials file, but in a pure Ruby project like this, the most suitable option I found is the `dotenv` gem, so I stored my API key in a `.env` as `ISBN_DB_API_KEY`, which makes it available to my code as `ENV['ISBN_DB_API_KEY']`.

#### ApiUtil

Seeing as I was on the topic of handling an API key, and the entire feature is based on making API calls, the next item to concentrate on was the code that does just that.  

I didn't want to make API calls specific to ISBN Fetcher, so in my `Util` module, I decided to create a small Module called `ApiUtil`, which would contain a wrapper `api_call`, which in turn would accept a Hash of API request parameters.

This way, `IsbnFetcher`, and any future features, could pass all the API request parameters in one simple Hash to the wrapper, and get back the API response.

To that end, I created another Spec file: `spec/cpc/util/api_util_spec.rb`

```ruby
require 'spec_helper'

RSpec.describe Cpc::Util::ApiUtil do
  include Cpc::Util::ApiUtil

  let(:args_hsh) do
    {
      url: "https://api2.isbndb.com/book/9781931499651?with_prices=0",
      request_headers: {
        "accept": 'application/json',
        "Authorization": ENV['ISBN_DB_API_KEY'],
        "cache-control": 'no-cache'
      }
    }
  end

  it 'should return book details of 9781931499651', online_extra: true do
    res = api_get_request(args_hsh)
    expect(res.code).to eq("200")
    expect(JSON.parse(res.body).keys.first).to eq("book")
  end
end
```

The code that passes this spec is in `lib/cpc/util/api_util.rb`:

```ruby
# frozen_string_literal: true

require 'uri'
require 'net/http'

module Cpc
  module Util
    module ApiUtil
      def api_get_request(args_hsh)
        url = URI(args_hsh[:url])
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(url)
        args_hsh[:request_headers].each { |k, v| request[k.to_s] = v }
        http.request(request)
      end
    end
  end
end
```

### Back to IsbnFetcher

With a reliable API wrapper in place, the role of the method `book_details` was clarified:
1. Take an ISBN String (`isbn_str`) and a box label (`box_str`) as parameters;
2. Create a Hash of API request parameters (`args_hsh`)
3. Pass the API request parameters Hash to the `Cpc::Util::ApiUtil.api_get_request(args_hsh)` wrapper
4. Parse the API response body (`res`)
5. Return a Hash containing the details of a book -- title, author, etc. (`details_hsh`)

#### (:let) Variables

If you have a paid ISBNdb account, you can use the API caller that is built into its API documentation page to collect a few samples.  For example, an API call for `9781931499651` will return the following details, which I added to `isbn_fetcher_spec.rb`:

```ruby
let(:long_title) {"Knitting Vintage Socks"}
let(:author) {"Nancy Bush"}
let(:publisher) {"Interweave"}
let(:binding_type) {"Spiral-bound"}
let(:pages) {128}
let(:date_published) {"2005"}
```

Which meant I could finally populate my `context` block from before with `it` blocks:

```ruby
context 'Authorised API key', online_extra: true do
  subject = Cpc::Toolkit::IsbnFetcher.new('ISBN_DB_API_KEY')
  context 'ISBN 9781931499651' do
    isbn_str = '9781931499651'
    box_str = '01 Craft'

    before(:all) do
      @book_details = subject.collect_book_details(isbn_str, box_str)
    end

    it 'should have the right headers' do
      expect(@book_details.keys).to eq(header_str_ary)
    end

    it 'should return book title from ISBNdb' do
      expect(@book_details[:isbn]).to eq(isbn_str)
    end

    it 'should return book title from ISBNdb' do
      expect(@book_details[:box]).to eq(box_str)
    end

    it 'should return book title from ISBNdb' do
      expect(@book_details[:long_title]).to eq(long_title)
    end

    it 'should return author from ISBNdb' do
      expect(@book_details[:author]).to eq(author)
    end

    it 'should return publisher from ISBNdb' do
      expect(@book_details[:publisher]).to eq(publisher)
    end

    it 'should return binding from ISBNdb' do
      expect(@book_details[:binding_type]).to eq(binding_type)
    end

    it 'should return page count from ISBNdb' do
      expect(@book_details[:pages]).to eq(pages)
    end

    it 'should return publication date from ISBNdb' do
      expect(@book_details[:date_published]).to eq(date_published)
    end
  end
```

And now I was ready to start writing the code.

### THE CODE

From here on, it is the familiar story of iteratively solving problems through TDD and BDD as they crop up:

* How do I package the API request parameters?
* How do I handle failed API requests? (Not "200")
* How do I save the result to CSV?

And so on.  The end result of this back-and-forth process are the methods:
* `book_details`
* `save_to_csv`
* `batch_fetch_save_to_csv`

Around which all the other methods in [isbn_fetcher.rb]() are written:

```ruby
def collect_book_details(isbn_str, box_str)
  puts "Fetching book details for #{isbn_str} in #{box_str} box"
  args_hsh = isbn_db_args(isbn_str)

  res = api_get_request(args_hsh)
  book_hsh = JSON.parse(res.body)["book"]
  response_code = res.code

  case response_code
  when "200"
    puts Rainbow("Details found for #{isbn_str}").green
    details_hsh = collect_details_book_found_true(isbn_str, box_str, response_code, book_hsh)
  else
    puts Rainbow("No details found for #{isbn_str}").red
    details_hsh = collect_details_book_found_false(isbn_str, box_str, response_code)
  end

  details_hsh
end

def save_to_csv(details_hsh, csv_filepath)
  no_headers = File.exist?(csv_filepath) == false || File.empty?(csv_filepath)
  write_to_csv(details_hsh, csv_filepath) if no_headers
  append_to_csv(details_hsh, csv_filepath) unless no_headers
end

def batch_fetch_save_to_csv(isbn_hsh_ary, csv_filepath)
  countdown = isbn_hsh_ary.count
  countup = 0

  isbn_hsh_ary.each do |isbn_hsh, box_str|
    isbn_str = isbn_hsh[:isbn]
    box_str = isbn_hsh[:box]

    details_hsh = collect_book_details(isbn_str, box_str)
    save_to_csv(details_hsh, csv_filepath)

    countdown -= 1
    countup += 1
    puts "ISBNs checked: #{countup}"
    puts "Books remaining: #{countdown}"
  end
end
```

## Conclusion

It could be argued that in the time it took to follow this process, I could have just written a script to achieve the same result.

However, this disciplined approach to the solution means that not only shall I be able to return to my code in the future and understand what it does, but my project is enhanced by the example of a clear Feature file, well organised Steps, organised RSpecs, an additional `Util` module, and clear, easy-to-follow code.  In the future, if I wish to extend or refactor this feature, or share my knowledge, this example will make life easier not only for me, but for anyone I collaborate with too.
