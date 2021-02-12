# CI/CD for Google Kubernetes Engine using Cloud Build

### Task 3.

```Dockerfile
    FROM python:3.7-slim
    RUN pip install flask
    WORKDIR /app
    COPY app.py /app/app.py
    ENTRYPOINT ["python"]
    CMD ["/app/app.py"]
```

---

https://cloud.google.com/solutions/managing-infrastructure-as-code