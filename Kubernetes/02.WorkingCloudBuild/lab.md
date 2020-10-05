```bash
nano quickstart.sh
```

qwickstart.sh

```
#!/bin/sh
echo "Hello, world! The time is $(date)."
```

Dockerfile 생성

```bash
nano Dockerfile
```

```
FROM alpine
COPY quickstart.sh /
CMD ["/quickstart.sh"]
```

# Task3. Build Containers

```
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
```

