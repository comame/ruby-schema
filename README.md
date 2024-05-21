# ruby-schema

## Sample

See [test_schema.rb](lib/test_schema.rb) for full examples.

```ruby
require 'schema'

schema = S.array_of S.hash(
    name: S.string,
    age: S.int,
)

schema.validate [{
    name: 'Alice',
    age: 20,
}, {
    name: 'Bob',
    age: 30,
}] #=> true
```

```ruby
# Gemfile
gem "schema", git: "https://github.com/comame/ruby-schema.git", tag: "v1.0.0"
```
