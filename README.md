Package Chrome extensions with Ruby. Based on [crxmake](https://github.com/Constellation/crxmake).

# Install

```
gem install extensionator
```

# Use

You need a private key so sign the extension with, and this is a BYOK (bring your own key) library. So first, you need a PEM file. If you have one, cool. If not, do this:

```
openssl genrsa -out key.pem 2048
```

You'll also need a directory to package up. Extensionator doesn't pay any attention to the contents; it just repackages them. So if you're misssing a `manifest.json` or your files are encoded wrong or whatever, you won't find out until you tried to load the packed extension into Chrome. Then:

```rb
Extensionator.create("directory_with_extension", "key.pem", "output_file.crx")
```

You can also exclude files with a regex:

```rb
Extensionator.create("dir", "key.pem", "output_file.crx", exclude: /\.md$/)
```
