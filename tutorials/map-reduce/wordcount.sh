#!/bin/sh

# Demo use of Essentia in 'mapreduce' mode.  Replicates
# simple 'wordcount' example
#
# clean out old spec files if they exist
ess server reset
# create schema
ess create database mapreduce
ess create vector wordcount s,pkey:word i,+add:count
# restart UDB to clean out old data
ess udbd restart
# import data.  Split words by punctuation and space, then load into UDB
cat pg98.txt | tr -s '[[:punct:][:space:]]' '\n' | \
               aq_pp -d s:word -eval i:count 1 -imp mapreduce:wordcount
# output the top 10 words.
aq_udb -exp mapreduce:wordcount -sort,dec count -top 10
