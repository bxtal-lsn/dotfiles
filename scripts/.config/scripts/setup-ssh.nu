#!/usr/bin/env nu

# Start SSH agent and set environment variables
^ssh-agent -c
    | lines
    | first 2
    | parse "setenv {name} {value};"
    | transpose -r
    | into record
    | load-env

# Add your Bitbucket key
ssh-add ~/.ssh/bitbucket
ssh-add ~/.ssh/id_rsa

