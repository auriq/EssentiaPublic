#!/bin/sh

# Demo use of Essentia in 'mapreduce' mode.  Replicates
# simple 'wordcount' example
#
ess instance local
# clean out old spec files if they exist
ess spec reset
# create schema
ess spec create database mapreduce
ess spec create vector wordcount s,hash:word i,+add:count
# restart UDB to clean out old data
ess udbd restart
# import data.  Split words by punctuation and space, then load into UDB
cat pg98.txt | tr -s '[[:punct:][:space:]]' '\n' | \
               aq_pp -d s:word -evlc i:count 1 -imp mapreduce:wordcount
# output the top 10 words.
aq_udb -exp mapreduce:wordcount -sort count -dec -top 10
