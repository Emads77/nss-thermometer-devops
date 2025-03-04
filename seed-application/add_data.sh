#!/bin/bash

# Parse the file data.md with bash with bash and add to the database by sending a POST HTTP request to the backend end point for goals.
# Make sure the backend end point is configurable by using environment variables. The script needs to work with input files, so pass `data.md` as an argument to the script.

# The json format in which your need to post the data has to look like this:
# { 
#     "name": "Custom NSE sticker (unique for this year!)",
#     "targetPercentage": 25,
# }

