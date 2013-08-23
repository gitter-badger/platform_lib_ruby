#!/bin/bash
action=$1
shift

ruby `dirname $0`/../lib/scripts/$action.rb $@