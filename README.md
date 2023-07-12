# Lyrical Ballads

This repository contains the code and data for creating a static version of the Lyrical Ballads project, formerly housed in SFU Library's digital collections. 

## How to build 

In all cases, first clone and navigate to the repository:

```bash
git clone https://github.com/sfu-dhil/lyrical-ballads
cd lyrical_ballads
```

### With Docker

*Requires*: Docker Desktop

First build the image:

```bash
docker build . -t lyricalballads:latest
```

The run `ant` using the `lyrical_ballads` image:

```bash
docker run -it -v $(pwd):/var/www lyricalballads ant -f build.xml
```

See `.github/workflows/build.yml` for example
### Linux / MacOS

Requires: `ant`, `imagemagick`, `sass`

```bash
ant -f build.xml
```

This triggers the entire build process, which should take approximately 15-30 seconds to run; the site will be in the `public` directory.

The entire site should be viewable in the browser from the `public` directory, but the search functionality requires a server to fetch the JSON index. If your lyrical_ballads directory is not already being served, then you can start a simple server of your choice in the `public` directory--for example, in Python:

```
cd public
python3 -m http.server 8080
```

## Structure

There are two main directories: the `ballad_data` directory contains all images and TEI XML files for the site; the `static` directory contains all code. All other directories are kept for historical purposes, but do not affect the static output.
