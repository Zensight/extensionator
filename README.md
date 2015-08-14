Package Chrome extensions with Ruby. Inspired by (Loosely based on? Stolen from?) [crxmake][crxmake-url]. Use the CLI or the Ruby API.

[![Gem Version][gem-img]][gem-url]
[![Gem Downloads][gem-dl-img]][gem-url]
[![Code Climate][code-climate-img]][code-climate-url]
[![License][license-img]][license-url]
![Phasers to stun][phasers-image]

# Install

```
gem install extensionator
```

# What you need

You need a private key so sign the extension with, and this is a BYOK (bring your own key) library. So first, you need a PEM file. If you have one, cool. If not, do this:

```
openssl genrsa -out key.pem 2048
```

You'll also need a directory to package up. Extensionator doesn't pay any attention to the contents; it just repackages them. So if you're misssing a `manifest.json` or your files are encoded wrong or whatever, you won't find out until you try to load the packed extension into Chrome.

# Command line

```
extensionator -d directory/with/extension -i key.pem -o output.crx
```

You can also exclude files with a regex, which will be applied to each level of the path (so if you have `foo/bar/baz.stuff`, we compare the regex to "foo", "foo/bar", and "foo/bar/baz.stuff"):

```
extensionator -d directory/with/extension -i key.pem -o output.crx -e "\.md$"
```

If you're one of *those* people, here's this thing:

```
-> extensionator -h
usage: /Users/isaac/.gem/ruby/2.1.5/bin/extensionator [options]
    -d, --directory  Directory containing the extension. (Default: .)
    -i, --identity   Location of the pem file to sign with. (Required)
    -o, --output     Location of the output file. (Default: 'extension.crx')
    -e, --exclude    Regular expression for filenames to exclude. (Default: \.crx$)
    -v, --version    Extensionator version info.
    -h, --help       Print this message.
```

# Programmatically

Same as above, but:

```rb
require "extensionator"
Extensionator.create("directory/with/extension", "key.pem", "output_file.crx")
```

Or with an `exclude` option:

```rb
Extensionator.create("dir", "key.pem", "output_file.crx", exclude: /\.md$/)
```

# License

The MIT License (MIT)

Copyright (c) 2015 Zensight

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[license-img]: http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square
[license-url]: http://opensource.org/licenses/MIT

[code-climate-img]: https://img.shields.io/codeclimate/github/Zensight/extensionator.svg?style=flat-square
[code-climate-url]: https://codeclimate.com/github/Zensight/extensionator

[gem-img]: https://img.shields.io/gem/v/extensionator.svg?style=flat-square
[gem-dl-img]: https://img.shields.io/gem/dt/extensionator.svg?style=flat-square
[gem-url]: https://rubygems.org/gems/extensionator

[crxmake-url]: https://github.com/Constellation/crxmake

[phasers-image]: https://img.shields.io/badge/phasers-stun-yellow.svg?style=flat-square
