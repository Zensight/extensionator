# Extensionator

Package Chrome extensions. Zip files or CRXs. Some convenience options. Use the command line or Ruby API.

[![Gem Version][gem-image]][gem-url]
[![MIT License][license-image]][license]
[![Gem Downloads][gem-dl-image]][gem-url]
[![Build Status][travis-image]][travis-url]
[![Code Climate][code-climate-image]][code-climate-url]
[![Dependencies][gemnasium-image]][gemnasium-url]

## Install

```
gem install extensionator
```

## Keys

If you plan on generating a CRX (as opposed to just a zip file to upload somewhere), you need a private key so sign the extension with, and this is a BYOK (bring your own key) library. So first, you need a PEM file. If you have one, cool. If not, do this:

```
openssl genrsa -out key.pem 2048
```

That's the file you'll use as `key.pem` below.

## Command line

```
extensionator -d directory/with/extension -i key.pem -o output.crx
```

Useful options! There are single-letter versions of most of these:

  * `-e` `--exclude`. Specify a regex of things to exclude. Matches on the whole path. `-e "\.md$"

  * `-f` `--format`. "zip" or "crx". Zip is what the Chrome store has you upload, since it does its own signing. You won't need the `-i` option unless you do something weird with the other options.

  * `--inject-key`. If you have an extension in the store, you know you can't have a "key" property in your manifest file. But if you do local developmentand want to keep your extension ID the same, you need that property in there. This is because Google hates you and wants to make your life hard. Fortunately, Extensionator can take your pem file, generate the public key, and put it in the manifest file before zipping up the extension. Yay!

 * `--inject-version`. Use this to override the "version" property in your manifest.

Here's the whole shebang:

```
-> extensionator --help
usage: /Users/isaac/.gem/ruby/2.1.5/bin/extensionator [options]
    -d, --directory   Directory containing the extension. (Default: .)
    -i, --identity    Location of the pem file to sign with.
    -o, --output      Location of the output file. (Default: 'extension.[zip|crx]')
    -e, --exclude     Regular expression for filenames to exclude. (Default: .crx$)
    -f, --format      Type of file to produce, either zip or crx. Defaults to crx
    --inject-version  Inject a version number into the manifest file.
    --inject-key      Inject a key parameter into the manifest file.
    -v, --version     Extensionator version info.
    -h, --help        Print this message.
```

## Programmatically

Same as above, but:

```rb
require "extensionator"
Extensionator.crx("directory/with/extension", "key.pem", "output_file.crx")
```

Or to create a zip:

```rb
Extensionator.zip("directory/with/extension", "output_file.zip")
```

Options go at the end of either method call, and just look just like the CLI ones, but as Ruby symbols:

```rb
Extensionator.crx("dir", "key", "output.crx", inject_version: "4.5.1",
                                              inject_key: true,
                                              exclude: /\.md$/)
```

## License

Copyright 2015 Zensight. Distributed under the MIT License. See the [LICENSE][] file for more details.

![Phasers to stun][phasers-image]

[license-image]: http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square
[license]: LICENSE.md

[code-climate-image]: https://img.shields.io/codeclimate/github/Zensight/extensionator.svg?style=flat-square
[code-climate-url]: https://codeclimate.com/github/Zensight/extensionator

[gem-image]: https://img.shields.io/gem/v/extensionator.svg?style=flat-square
[gem-dl-image]: https://img.shields.io/gem/dt/extensionator.svg?style=flat-square
[gem-url]: https://rubygems.org/gems/extensionator

[travis-url]: http://travis-ci.org/Zensight/extensionator
[travis-image]: http://img.shields.io/travis/Zensight/extensionator.svg?style=flat-square

[gemnasium-url]: https://gemnasium.com/zensight/extensionator
[gemnasium-image]: https://img.shields.io/gemnasium/Zensight/extensionator.svg?style=flat-square

[crxmake-url]: https://github.com/Constellation/crxmake

[phasers-image]: https://img.shields.io/badge/phasers-stun-green.svg?style=flat-square
