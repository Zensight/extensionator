# Extensionator

Package Chrome extensions. Zip files or CRXs. Some convenience options. Use the command line or Ruby API.

[![Gem Version][gem-image]][gem-url]
[![MIT License][license-image]][license]
[![Gem Downloads][gem-dl-image]][gem-url]
[![Build Status][travis-image]][travis-url]

## You probably don't need this anymore

Extensionator made it really easy to build and pacakge CRX files, which was really annoying. Chrome's fixed most of that;

 * CRX files aren't supported by Chrome anymore and you can use zip files for non-store distribution
 * The Chromestore no longer cares if you include a key in the submitted manifest, which was previously a huge PITA
 
These simplifications mean it's almost easy to use a standard zip tool; the only thing Extensionator adds for you is the ability to inject the version number into the manifest, which seems like a questionable amount of value for a build tool to add. We're leaving this up because there's no reason to take it down, but FWIW, we don't use it anymore ourselves.

## Install

```
gem install extensionator
```

## Identity

If you plan on generating a CRX (as opposed to just a zip file to upload somewhere), you need a private key to sign the extension with, and this is a BYOK (bring your own key) library. So first, you need a PEM file. If you have one, cool. If not, do this:

```
openssl genrsa -out identity.pem 2048
```

That's the file you'll use as `identity.pem` below.

## Command line

```
extensionator -d directory/with/extension -i identity.pem -o output.crx
```

Useful options!

  * `-e` `--exclude`. Specify a regex of things to exclude. Matches on the whole path. `-e "\.md$"`

  * `-f` `--format`. "zip", "dir" or "crx". Zip is what the Chrome store has you upload, since it does its own signing. You won't need the `-i` option unless you do something weird with the other options. Dir is useful for using the inject_key option with.

  * `--inject-key`. If you have an extension in the store, you know you can't have a "key" property in your manifest file. But if you do local unpacked development and want to keep your extension ID the same, you need that property in there. This is because Google hates you and wants to make your life hard. Fortunately, Extensionator can take your pem file, generate the public key, and put it in the manifest file before writing the extension. Yay!

  * `--strip-key`. Alternatively, your workflow may make more sense leaving the key in your source file and stripping it out when you build your zip. Up to you!

  * `--inject-version`. Use this to override the "version" property in your manifest.

Here's the whole shebang:

```
-> extensionator
usage: /Users/isaac/.gem/ruby/2.2.4/bin/extensionator [options]
    -d, --directory    Directory containing the extension. (Default: .)
    -i, --identity     Location of the pem file to sign with.
    -o, --output       Location of the output file. (Default: 'output[.zip|.crx|]')
    -e, --exclude      Regular expression for filenames to exclude. (Default: .crx$)
    -f, --format       Type of file to produce, either 'zip', 'dir' or 'crx'. (Default: crx)
    --inject-version   Inject a version number into the manifest file. (Default: none)
    --inject-key       Inject a key parameter into the manifest file. (Default: no)
    --strip-key        Remove the key parameter from the manifest file. (Default: no)
    --skip-validation  Don't try to validate this extension. Currently just checks that the manifest is parsable.
    -v, --version      Extensionator version info.
    -h, --help         Print this message.
```

## Programmatically

Create a CRX:

```rb
require "extensionator"
Extensionator.crx("directory/with/extension", "output_file.crx", identity: "identity.pem")
```

Or to create a zip:

```rb
Extensionator.zip("directory/with/extension", "output_file.zip")
```

Or a directory:

```rb
Extensionator.dir("directory/with/extension", "output_dir")
```

Options go at the end of any method call, and just look just like the CLI ones, but as Ruby symbols:

```rb
Extensionator.crx("dir", 
                  "output.crx",
                  identity: "identity.pem",
                  inject_version: "4.5.1",
                  strip_key: true,
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

[crxmake-url]: https://github.com/Constellation/crxmake

[phasers-image]: https://img.shields.io/badge/phasers-stun-brightgreen.svg?style=flat-square
