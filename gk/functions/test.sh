#!/bin/bash

test_userprompt() {
	source userprompt.sh
	userprompt "Is this a test?"
	local choice=$choice_1
	userprompt "What about this?"
	local choice_2=$choice_1
	userprompt + "And now?"
	local choice_3=$choice_2

	echo "Results:"
	echo "Choice 1: $choice"
	echo "Choice 2: $choice_1"
	echo "Choice 3: $choice_2"
}
