# cchardet

Ruby bindings for freedesktop.org's uchardet (<https://gitlab.freedesktop.org/uchardet/uchardet>).

By default, this gem depends on the system uchardet. Alternatively, it can build
the unreleased `wip/Jehan/improved-API` branch of uchardet as a native extension.
Note that uchardet's license terms may differ from those of this gem.

## Installation

### System uchardet

Add this line to your application's Gemfile:

```ruby
gem "cchardet"
```

And then execute:

```
bundle install
```

Or install it yourself as:

```
gem install cchardet
```

### Unreleased branch as native extension

When using bundler:

```
bundle config set --global build.cchardet --with-unreleased-uchardet
bundle install
```

When using gem directly:

```
gem install cchardet -- --with-unreleased-uchardet
```

## Usage

```ruby
require "cchardet"

CChardet.detect(unknown_bytes)
# released uchardet:
#   { encoding: "UTF-8" }
# unreleased native extension:
#   { encoding: "UTF-8", confidence: 1.0, language: nil }
```

The only public interface is `CChardet.detect`, which takes a sequence of bytes.

When using a released version of uchardet, it will return a hash with a single
element, `encoding`, indicating the detected encoding of the byte stream. Future
versions of uchardet are likely to provide additional fields (see <https://gitlab.freedesktop.org/uchardet/uchardet/-/issues/5#note_474963>).

When using the unreleased native extension, it will return an array of hashes
having three elements:

- `encoding` – Detected encoding of the byte stream
- `confidence` – Confidence of the encoding value
- `language` – Detected language, if known

The hashes are ordered by descending confidence.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/elebow/cchardet>.

## License

MIT License.

Note that uchardet, which may be compiled as a native extension, is covered by its
own license.
