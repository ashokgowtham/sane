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
