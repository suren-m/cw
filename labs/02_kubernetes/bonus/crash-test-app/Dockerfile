FROM python:3-slim
WORKDIR /

RUN pip install flask 
COPY app.py /app.py

STOPSIGNAL SIGINT
CMD ["python", "/app.py"]
