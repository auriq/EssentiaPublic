# EssentiaPublic

This repository contains the data and scripts used at the [Essentia Documentation Portal](http://www.auriq.com/documentation/).
What is Essentia? It is a general pupose but very power text processing engine.  It provides ETL tools, an in-memory map/reduce style database, and file management/accounting.  If you use it on Amazon Web Services (AWS), all of the tools can be scaled to handle massive workloads.

For more information, please visit the [Essentia Home Page](http://www.auriq.com).

## Description of files


1. **tutorials** contains all of the raw data and scripts used in the tutorials.
2. **casestudies** contains the data and scripts for the 'Examples / Local Datastore' area of
   the documentation.
3. **shellscripts** contains tests and examples of Essentia commands that work with open datasets 
   stored on a public S3 bucket.
4. **aws** contains the scripts used when demonstrating how Essentia scales on the cloud.
   The data associated with these are too large to distribute, so we have made available
   a public S3 bucket that stores the data.
