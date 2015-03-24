Package Chrome extensions with Ruby. Inspired by (Loosely based on? Stolen from?) [crxmake](https://github.com/Constellation/crxmake).

# Install

```
gem install extensionator
```

# Use

You need a private key so sign the extension with, and this is a BYOK (bring your own key) library. So first, you need a PEM file. If you have one, cool. If not, do this:

```
openssl genrsa -out key.pem 2048
```

You'll also need a directory to package up. Extensionator doesn't pay any attention to the contents; it just repackages them. So if you're misssing a `manifest.json` or your files are encoded wrong or whatever, you won't find out until you try to load the packed extension into Chrome.

OK, ready:

```rb
Extensionator.create("directory_with_extension", "key.pem", "output_file.crx")
```

You can also exclude files with a regex, which will be applied to each level of the path (so if you have `foo/bar/baz.stuff`, we compare the regex to "foo", "foo/bar", and "foo/bar/baz.stuff"):

```rb
Extensionator.create("dir", "key.pem", "output_file.crx", exclude: /\.md$/)
```

# License

The MIT License (MIT)

Copyright (c) 2015 Isaac Cambron

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
