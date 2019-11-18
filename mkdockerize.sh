#! /usr/bin/env bash
set -e 
if [[ "$1" == "produce" ]]; then
    shift
    #setting default direcory for the project in case user did not provide
    DIR=`pwd`
    #parsing user aguments
    while [ $# -gt 0 ]; do
        case "$1" in
            --docs-dir=*)
                DIR="${1#*=}"
            ;;
            --static-only)
                STATIC_ONLY="true"
            ;;
        *)
            echo "Invalid argument: $1"
            echo "Usage: mkdockerize.sh produce [--static-only] [--docs-dir={path_to_dir}]"
            exit 1
        esac
        shift
    done
    #a bit redundant passing of the parameter
    if [[ "$STATIC_ONLY" == "true" ]]; then
        docker run --rm --name mkdocs-produce -v $DIR:/mkdocs:ro mkdocs produce --static-only
    else
        docker run --rm --name mkdocs-produce -v $DIR:/mkdocs:ro mkdocs produce 
    fi
elif [[ "$1" == "serve" ]]; then
    #serving mkdocs on port 8000 with input open and stdin passed from piped command
   docker run --rm --name mkdocs-serve -i -p 8000:8000 mkdocs serve -
else
    echo "Usage: mkdockerize.sh serve|produce [OPTIONS]"
fi