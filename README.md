# Sane

Simple gem to run validations. Not web based. Ideal for crons and scheduler.

## Installation

Add this line to your application's Gemfile:

    gem 'sane'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sane

## Usage

```ruby
models = { :files => ["path/to/file1","path/to/file2","path/to/file3"] }
inspector = Sane::Inspector.new([Sane::SubInspectors::FileExistsInspector.new, Sane::SubInspectors::FileValidInspector.new])
models.each do |key, value|
	value['paths'].each do |path|
		Sane.sanitize path, expander, &(inspector.checker)
	end
end

expander = lambda { |path| [path] }
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/sane/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
