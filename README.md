# ActiveServices

An easy and intuitive way to add *Service Objects* to your rails application`.

Services generated with this gem will follow a few simple rules:
  1) Must operate on a single object (though they can perform trivial updates on other objects)
  2) Must return a `Result` object (more on that in the `Usage` section)
  3) Must only have a single public method `call` all other methods are private.

### Why Service Objects?

There are many times where we end up with logic that doesn't necessarily belong to a particular model due to the complextity
of the operation, so it ends up in the controller which also is not the best place for it to live. That's where Service Objects come in to the rescue. They allow you to move that logic to it's own object, that is easily testable due to it's nature as a PORO (Plain Old Ruby Object).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_services'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_services

And then to get set up run

    $ bundle exec rails generator active_services:install

## Usage

### Post Intallation

Running the install task sets you up with some new files. Let's explore how to use them.

The main thing to notice is the new `app/services` directory. In this directory you will also see the `active_service.rb`
file which looks like this:

```ruby
class ActiveService < ActiveServices::ServiceObject
  # Your custom code to be shared across all service objects here
  # All your service objects should inherit from the ActiveService class
end
```

Which is pretty barebones to start off with, but it is here that you can define common behavior between all your Service Objects.

### Making New Service Objects

To start using Service Objects in your rails application is as easy as running:

    $ bundle exec rails generate active_services:new [MODEL] [SERVICE]

For example, if you're creating a service to create new instances of a `Comment` model you would run:

    $ bundle exec rails generate active_services:new Comments Create

Which would generate the `Create` service in the `app/services/comments` directory (and create that directory if it already doesn't exist) like this:

```ruby
# app/services/comments/create.rb
module Comments
  class Create < ActiveService
    def initialize
    end

    def call
    end
  end
end
```

And that's it! You've got yourself a brand new Service Object to start working with.

### Using Service Objects

Now that you've got your Service Object let's start adding some functionality to it. Let's say that comments can be nested,
so when creating a new one, if it's the child of another comment, we have to update the parent comment to have the child comments
id.

```ruby
# app/services/comments/create.rb

module Comments
  class Create < ActiveService
    attr_reader :text, :service
    attr_accessor :parent

    def initialize(text:, author:, parent_id: nil)
      @text   = text
      @author = author
      @parent = Comment.find(parent_id) || nil
    end

    def call
      comment = create_comment
      result(comment)
    end

    private

    def create_comment
      comment = Comment.new(text: text, author: author, parent: parent)
      saved = comment.save
      update_parent(comment) if can_update_parent(saved)
    end

    def can_update_parent?(saved)
      parent && saved
    end

    def update_parent(comment)
      parent.update_attributes(parent: parent)
    end
  end
end
```

And to use this Service Object in your Controller

```ruby
# app/controllers/comments_controller.rb
class CommentsController < ApplicationController

  def create
    service = Comments::Create.new(text: params[:text], author: params[:author], parent_id: params[:parent_id])
    result  = service.call()

    if result.success?
      @comment = result.model
      redirect :index
    else
      render :new, errors: result.errors
    end
  end
end
```

This code here will create the comment, update the parent comment if necessary, and return the Result Object. The next section
will take a look at the Result Object.

### The Result Object

Each Service Object should return a Result Object, which is returned by using the `result` method which is defined in the base
`ServiceObject` model. This object has three public methods available for use:

  1) `.model`: This returns the model that was operated on by the Service Object.
  2) `.errors`: This will return the array of full error messages (if any) for the object operated on by the Service Object.
  3) `.success?`: This will return a boolean based on whether the operation was successful or not.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jm96441n/active_services. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. For more information check out our [code of conduct](https://github.com/jm96441n/active_services/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveServices project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jm96441n/active_services/blob/master/CODE_OF_CONDUCT.md).
