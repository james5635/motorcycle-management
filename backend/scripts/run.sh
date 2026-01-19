#!/bin/bash

while true; do
    echo "Press r to run, q to quit"
    read -n 1 key
    echo

    case "$key" in
        r)
            gradle compileJava
            ;;
        q)
            echo "Bye!"
            break
            ;;
    esac
done
