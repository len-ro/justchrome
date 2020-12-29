#!/bin/bash

CHROME=main

docker exec -i $CHROME /usr/bin/xdg-open "$@"