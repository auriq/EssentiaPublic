# EssentiaPublic

This repository contains the data and scripts used at the [Essentia Documentation Portal](http://www.auriq.net/documentation/).
What is Essentia? It is a general pupose but very power text processing engine.  It provides ETL tools, an in-memory map/reduce style database, and file management/accounting.  If you use it on Amazon Web Services (AWS), all of the tools can be scaled to handle massive workloads.

For more information, please visit the [Essentia Home Page](http://www.auriq.net)

## Description of files


1. **data** contains all of the raw data used in the tutorials.
2. **scripts** contain most of the scripts used. The documentation itself has smaller code snippets at times that are not replicated here.
3. **aws** contains the scripts used when demonstrating how Essentia scales on the cloud.  The data associated with these are too large to distribute, so we have made available a public S3 bucket that stores the data.
