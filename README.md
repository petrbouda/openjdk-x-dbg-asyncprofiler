# OpenJDK Docker Imager with Debugging Symbols and AsyncProfiler

```
docker build -t openjdk-15-dbg-asyncprofiler:latest .
```

- use `openjdk-15-dbg-asyncprofiler:latest` as a base image

```
<plugin>
    <groupId>com.google.cloud.tools</groupId>
    <artifactId>jib-maven-plugin</artifactId>
    <version>2.5.2</version>
    <configuration>
        <from>
            <image>docker://openjdk-15-dbg-asyncprofiler:latest</image>
        </from>
        <to>
            <image>tested-app:latest</image>
        </to>
        <container>
            <jvmFlags>
                <jvmFlag>-XX:+UnlockDiagnosticVMOptions -XX:+DebugNonSafepoints</jvmFlag>
            </jvmFlags>
        </container>
    </configuration>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>dockerBuild</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

```
# Start application
docker run -it --rm --network host --name tested-app -v /tmp/asyncprofiler:/tmp/asyncprofiler --security-opt seccomp=unconfined tested-app:latest

# Start profiling
docker exec -ti tested-app profiler.sh 60 -t -f /tmp/async-profiler/cpu.svg 1

# Grep result
cd /tmp/asyncprofiler
```

If you want to execute Profiler outside the container then you need to place `async-profiler` on the same place as inside the image
```
/usr/lib/async-profiler

# Execute the Profiler
# User needs to be the same as the user inside the container

docker top tested-app                                                                       [20/10/6|10:49AM]
UID       PID       PPID      C         STIME     TTY       TIME      CMD
root      342895    342878    99        10:50     pts/0     00:00:07  java -cp

sudo /usr/lib/async-profiler/profiler.sh -d 10 -t -f /tmp/asyncprofiler/cpu.svg 342895
```

