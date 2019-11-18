# MKDocs dockerized

## About

This project provides dockerized version of mkdocs. Takes directory with mkdcos configuration and docs dir and returns a tar.gz file content produced by mkdocs to be either saved as a 

## Installation

### Prerequisites

* Valid mkdocs.yml configuration file in projects root directory
* All the required .md files should be stored in docs/ sudirectory
* (Optionally) if extra python packages are used with mkdocs, they should be listed in requirements/docs.txt file

### Building project

Simply build it with

```shell
docker build -t mkdocs .
```

### Testing

`test.sh` contains a simple test that downloads current mkdocs master from github and tries to build and serve it using `mkdockerize.sh`. Then validates if produced website contains MKDocs tag.

## Usage

```shell
./mkdockerize.sh produce | serve
```

* **produce** *[--docs-dir={dir}] [--static-only]*
  
   Takes current directory and builds mkdocs project with it. The resulting tarball contains of both: produced content and mkdocs project directory, ready to be served by the serve command.
    - *--docs-dir* - absolute path to mkdocs project, if not provided, current dir will be used
    - *--static-only* - the output tarball contains only static website resources produced by mkdocs, ready to be served by any http server of your desire

* **serve**

    Takes contents of the​ .tar.gz​ file produced by the *produce* command and serves it on port 8000.

    **Warning**: the input file needs to contain full mkdocs project (not just static files).