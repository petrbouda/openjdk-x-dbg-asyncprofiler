# Multi-Stage Reason:
#
# - build `async-profiler` using AdoptOpenJDK
# - contains header files in `include` folder - e.g. jvmti.h
# - openjdk-15-dbg from Ubuntu:groovy contains just debugging symbols and is faster then `fastdebug` version

#
# THE FIRST STAGE - build `async-profiler`
#
FROM adoptopenjdk/openjdk11 AS builder

RUN apt update && apt install -y cmake g++ git

RUN git clone --depth=1 https://github.com/jvm-profiling-tools/async-profiler /async-profiler &&\
    cd /async-profiler &&\
    make

#
# THE SECOND STAGE - copy `async-profiler` and downloado `penjdk-15-dbg`
#
FROM ubuntu:groovy

RUN apt update && apt install -y openjdk-15-dbg

COPY --from=builder /async-profiler /usr/lib/async-profiler

ENV JAVA_HOME=/usr/lib/jvm/java-15-openjdk-amd64
ENV PROFILER_HOME=/usr/lib/async-profiler
ENV PATH=$PATH:$PROFILER_HOME:$JAVA_HOME/bin

CMD ["jshell"]