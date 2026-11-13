#!/bin/sh
set -e
APP=/app
HOST="${RENDER_EXTERNAL_HOSTNAME:-localhost}"
M="$APP/backend/models"

export PALLETSORT_ENVIRONMENT=production
export PALLETSORT_WEB_DIR="$APP/web"
export PALLETSORT_DB_PATH="$APP/data/palletsort.db"
export PALLETSORT_OPERATION_IMAGES_DIR="$APP/data/operation_images"
export PALLETSORT_ALLOWED_HOSTS="$HOST,*.onrender.com,localhost,127.0.0.1"
export PALLETSORT_ALLOWED_ORIGINS="https://$HOST"
export PALLETSORT_PUBLIC_APP_URL="https://$HOST"
export PALLETSORT_PUBLIC_BASE_URL="https://$HOST"
export PALLETSORT_TRUST_PROXY_HEADERS=true
export PALLETSORT_TEST_SIGNUP_ENABLED=true
# Na demonstração pública o 2FA por e-mail fica desligado (cadastro de teste sem e-mail).
export PALLETSORT_REQUIRE_2FA="${PALLETSORT_REQUIRE_2FA:-false}"
export PALLETSORT_ALLOW_DEBUG_OTP=false
export PALLETSORT_FIREBASE_ENABLED=false
export PALLETSORT_WARMUP_MODELS=true
export PALLETSORT_INFERENCE_BACKEND=onnx
export PALLETSORT_ONNX_THREADS=1
export OMP_NUM_THREADS=1
export PALLETSORT_MODEL_PATH="$M/pallet_detector_mobile_operational_v3.pt"
export PALLETSORT_DETECTOR_IMGSZ=416
export PALLETSORT_DETECTOR_CONFIDENCE=0.25
export PALLETSORT_DETECTOR_IOU=0.45
export PALLETSORT_DAMAGE_CLASSIFIER_PATH="$M/pallet_damage_classifier.pt"
export PALLETSORT_DAMAGE_CLASSIFIER_METADATA_PATH="$M/pallet_damage_classifier.json"
export PALLETSORT_TYPE_MODEL_PATH="$M/pallet_type_classifier_v2_20261103.pt"
export PALLETSORT_TYPE_MODEL_METADATA_PATH="$M/pallet_type_classifier_v2_20261103.json"
# Segredos: defina em Settings > Variables and secrets. Sem eles, gera valores
# aleatórios (as contas de exemplo ficam inacessíveis; use o cadastro de teste).
if [ -z "$PALLETSORT_SEED_PASSWORD" ]; then
  PALLETSORT_SEED_PASSWORD="Seed-$(python -c 'import secrets;print(secrets.token_urlsafe(24))')"
  export PALLETSORT_SEED_PASSWORD
fi
if [ -z "$PALLETSORT_OTP_PEPPER" ]; then
  PALLETSORT_OTP_PEPPER="$(python -c 'import secrets;print(secrets.token_urlsafe(48))')"
  export PALLETSORT_OTP_PEPPER
fi
mkdir -p "$APP/data/operation_images"
cd "$APP"
exec uvicorn backend.main:app --host 0.0.0.0 --port "${PORT:-10000}" \
  --proxy-headers --forwarded-allow-ips='*' --workers 1
