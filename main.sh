#!/bin/bash

RUNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$RUNDIR/docker/run.sh -i len/mainenv:1.0 -n main -s main.sh

