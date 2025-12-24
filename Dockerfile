FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app .

RUN pytest test/test_app.py -v --cov=app --cov-report=term-missing

FROM python:3.11-slim

WORKDIR /app

RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --from=builder /app/src/app.py .

USER appuser

ARG APP_VERSION="v0.0.0"
ENV APP_VERSION=$APP_VERSION
ENV PORT=8080

EXPOSE $PORT

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
   CMD wget -qO- http://localhost:$PORT/health || exit 1

CMD ["python", "app.py"]