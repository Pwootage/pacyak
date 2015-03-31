# pacyak, the OC Package Yak

pacyak is a simple package manager designed to make it relatively easy to create
and maintain custom lists of packages - which can be served from any standard
web server (including github's raw content!)

# How to use

* Download [install.lua](install.lua)
* Add URLs of lists to [/etc/pacyak/lists.txt](etc/lists.txt)
* "pacyak update" will download newest lists (using URLs in lists.txt)
* "pacyak list" will list all avalable packages
* "pacyak install &lt;package&gt;" will install the package specified
* "pacyak uninstall &lt;package&gt;" will uninstall the package specified

# Adding a package list

Simple key=value list, seperated by new lines:
```
pacyak=https://raw.githubusercontent.com/Pwootage/pacyak/master/pacyak.list
mystuff=https://example.com/packages/mystuff.list
```

# Creating a package list
Again, simple key=value list, seperated by new lines
```
pacyak=https://raw.githubusercontent.com/Pwootage/pacyak/master
test=https://raw.githubusercontent.com/Pwootage/pacyak/master/test
```
Each item must point to the root of a package directory

# Creating a package
The package *must* have a [package.json](package.json) in the root of the project.

Format:

(note comments are invalid json and are added for your benefit in this example):
```javascript
{
  /* Package Name (no spaces!) */
  "name": "pacyak",
  /* Version number (mostly for user information) */
  "version": "1.0.0",
  /* List of files to download into your package's directory */
  /* /usr/share/pacyak/<package name>/ */
  /* Note all of the below options must be specified here too! */
  "files": [
    "package.json",

    "bin/98_pacyak.lua",
    "bin/pacyak.lua",

    "lib/json.lua",
    "lib/libpacyak.lua",

    "etc/lists.txt"
  ],
  /* Symlinks to create */
  /* Destination: Target (Relative to package root) */
  "links": {
    "/usr/bin/pacyak.lua": "bin/pacyak.lua"
  },
  /* Files to install to specific locations */
  /* Destination: Source (Relative to package root) */
  "install": {
    "/boot/98_pacyak.lua": "bin/98_pacyak.lua",
    "/etc/pacyak/lists.txt": "etc/lists.txt"
  }
}
```

# TODO

* Error handling (network errors will crash, hard)
* Better CLI
* Package updates (instead of just installs/uninstalls)
* CLI for managing lists
* Create a centralized list of program lists (with appropriate warnings)
* Split up libpacyak a bit more?

# License
Copyright (c) 2015 Pwootage

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
