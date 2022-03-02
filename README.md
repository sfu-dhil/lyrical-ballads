# Lyrical Ballads

This repository contains the code and data for creating a static version of the Lyrical Ballads project, formerly housed in SFU Library's digital collections. 

## How to build

Requires: `ant`, `imagemagick`, `sass` 

To build the site, clone the repository (and make sure to fetch all submodules), and then run `ant` in the directory:

```
cd lyrical_ballads
ant
```

This triggers the entire build process, which should take approximately 15-30 seconds to run; the site will be in the `public` directory.

The entire site should be viewable in the browser from the `public` directory, but the search functionality requires a server to fetch the JSON index. If your lyrical_ballads directory is not already being served, then you can start a simple server of your choice in the `public` directory--for example, in Python:

```
cd public
python3 -m http.server 8080
```

## Structure

There are two main directories: the `ballad_data` directory contains all of the images and TEI XML files for the site; the `static` directory contains all of the code. All other directories are kept for historical purposes, but do not affect the static output.