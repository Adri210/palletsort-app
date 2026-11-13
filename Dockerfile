# PalletSort - Render (Docker, plano gratuito 512 MB)
# Etapa 1: compila o app Flutter Web a partir do código-fonte.
FROM ghcr.io/cirruslabs/flutter:3.41.7 AS web
WORKDIR /src
COPY bundle/ /tmp/bundle/
RUN cat /tmp/bundle/palletsort_bundle.tar.gz.part* | tar -xz -C /src
WORKDIR /src/app
RUN flutter config --enable-web \
 && flutter pub get \
 && flutter build web --release --dart-define=PALLETSORT_API_URL=same-origin

# Etapa 2: API FastAPI com IA em ONNX Runtime (sem PyTorch) + app web.
FROM python:3.11-slim
WORKDIR /app
COPY requirements-render.txt .
RUN pip install --no-cache-dir -r requirements-render.txt
COPY --from=web /src/app/backend ./backend
COPY --from=web /src/app/build/web ./web
COPY start.sh .
RUN chmod +x start.sh && mkdir -p data
ENV PYTHONUNBUFFERED=1
CMD ["./start.sh"]
