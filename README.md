## onigmo-ruby

![Unit Tests](https://github.com/camertron/onigmo-ruby/actions/workflows/unit_tests.yml/badge.svg?branch=main)

The [Onigmo](https://github.com/k-takata/Onigmo) regular expression engine compiled to WASM and wrapped in a Ruby embrace.

## What is this thing?

I know what you're thinking. Onigmo is built into Ruby - why is this project necessary?? Simple! I created it to serve as an example of how to interact with a WASM module in Ruby. Onigmo is a non-trivial project and one that has real-world use-cases, which makes it a better case study than many of the examples that can be found online.

So, please don't use this project as your regular expression engine. But please _do_ use it to learn how to call WASM functions from Ruby, read WASM memory, etc etc.

## Usage

Compile a regex:

```ruby
re = Onigmo::OnigRegexp.compile("[abc]")
```

Search for text:

```ruby
match_data = re.search("foo a zoo")

match_data.captures      # => [[4, 5]]
match_data.match(0)      # => "a"
match_data.get_begin(0)  # => 4
match_data.get_end(0)    # => 5
```

## Running Tests

`bundle exec rake` should do the trick.

## License

Licensed under the MIT license. See LICENSE for details.

## Authors

* ongimo-ruby: Cameron C. Dutro: http://github.com/camertron
* Onigmo: K. Takata: https://github.com/k-takata
