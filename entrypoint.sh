#! /usr/bin/env bash
set -e 
if [ -z "$1" ]; then
    mkdocs --help
elif [[ "$1" == "produce" ]]; then
    #installing plugins if required
    if [ -f 'requirements/docs.txt' ] ; then
        pip install --quiet -r requirements/docs.txt
    fi
    mkdocs build -q -d /tmp/mkdocs-produce
    #checking if user requested only static content
    if [[ "$@" =~ .*static-only.* ]]; then
        tar fcz - -C /tmp/mkdocs-produce .
    else
        tar fcz - -C /mkdocs . -C /tmp/mkdocs-produce .
    fi
elif [[ "$1" == "serve" ]]; then
    #switching stdin to point to produced tar content
    shift
    cat - | tar zxf -
    #installing plugins if required
        if [ -f 'requirements/docs.txt' ] ; then
        pip install --quiet -r requirements/docs.txt
    fi
    # using the -a flag to bind mkdocs to docker output
    mkdocs serve -a 0.0.0.0:8000
else 
    exec "$@"
fi