# docker-hadoop-test

* Hadoop testing on local environment with amazonlinux
    * Hadoop 2.7.3
    * Hive 2.1.1

# development

```
$ git clone <this-repsitory>
$ cd docker-hadoop-test
$ docker build -t docker-hadoop-test[:tag] .
$ docker run -i -t -d docker-hadoop-test /bin/bash

// check your docker process name !
$ docker attach <NAME>
```
