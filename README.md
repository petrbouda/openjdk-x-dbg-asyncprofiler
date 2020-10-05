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
