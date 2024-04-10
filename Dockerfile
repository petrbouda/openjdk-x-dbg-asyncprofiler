# Multi-Stage Reason:
#
# - build `async-profiler` using AdoptOpenJDK
# - contains header files in `include` folder - e.g. jvmti.h
# - openjdk-15-dbg from Ubuntu:groovy contains just debugging symbols and is faster then `fastdebug` version

#
# THE FIRST STAGE - build `async-profiler`
#
FROM ubuntu AS builder

RUN apt update && apt install -y openjdk-21-jdk cmake g++ git

RUN git clone --depth=1 https://github.com/jvm-profiling-tools/async-profiler /async-profiler &&\
    cd /async-profiler &&\
    make

#
# THE SECOND STAGE
# - install `openjdk-15-dbg` as a Runtime JVM (fast + debug symbols)
# - download AdoptOpenJDK that contains all other OpenJDK tools (e.g. jcmd)
# - copy `async-profiler`
#
FROM ubuntu

RUN apt update && apt install -y openjdk-21-dbg openjdk-21-jdk

# Install necessary tools
RUN apt install -y binutils

COPY --from=builder /async-profiler /usr/lib/async-profiler

ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PROFILER_HOME=/usr/lib/async-profiler
ENV PATH=$PATH:$PROFILER_HOME:$JAVA_HOME/bin

CMD ["jshell"]
