# Sane

Simple gem to run validations. Not web based. Ideal for crons and schedulers.

## Installation

Add this line to your application's Gemfile:

    gem 'sane'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sane

## Usage

### Expanders

Expanders are preprocessors that allow you to infer models from a class.

For E.g. lets take a class of files represented by the String: path/to/%folder%/file_%suffix%.csv.

1. An expander can be now thought of a preprocessor that can be used to convert this String with placeholders to all possible combinations.
2. Expanders should return an array of Strings back
3. Every entry returned back by the expander would be pushed individually downstream for sanity check.

E.g.

```ruby

lambda { |path| //Do something with path and return a array of models [...] }

```

### Sub Inspectors

Multiple Sanity tests can be stacked and applied in an orderly fashion to every model. You do this using sub inspectors.

* You are allowed to define one inspector who controls various sub-inspectors

```ruby

inspector = Sane::Inspector.new([Sane::SubInspectors::FileExistsInspector.new, Sane::SubInspectors::FileValidInspector.new])

```

* The inspector will fail fast, i.e break on the first failing sub-inspector.
* You currently get two sub inspectors from the gem as shown above - Names self explanatory. However you are free to write specific sub-inspectors based on a need basis.

#### Writing Custom Sub Inspectors

* Class with a method checker that returns a lambda
* The lambda would receive the model.
* Nothing more to say.

```ruby

class FileExistsInspector
      def checker
        lambda do |file|
          raise('File Not Found') unless File.exists? file
        end
      end
    end

```

## Bringing the DSL together

### Write essays :P

Its just Ruby :)

```ruby

    expander = lambda { |path| [path] }
    inspector = Sane::Inspector.new([Sane::SubInspectors::FileExistsInspector.new, Sane::SubInspectors::FileValidInspector.new])

    Sane.sanitize "path/to/file1", lambda { |path| [path] }, &(inspector.checker)
    Sane.sanitize "path/to/another_file", lambda { |path| [path] }, &(Sane::Inspector.new([Sane::SubInspectors::FileExistsInspector.new]).checker)

```

### Group and apply

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

## Reporters

* The inspector can be passed a reporter instance which keeps tracks of errors.
* This defaults to a new instance of the reporter in the gem on every inspector.
* if you are using muliple inspectors, it would make sense to use a single instance of reporter and pass it explicitly to the inspector on creation
* Look at the default reporter in Sane::Reporter to extend or plug and play.
