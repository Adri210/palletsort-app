# PalletSort

Triagem inteligente de paletes **PBR** e **descartáveis** com visão computacional.
TCC de Engenharia de Software — Centro Universitário Campo Real.

## Experimente

**App online:** https://palletsort.onrender.com

1. Abra o link no celular ou no computador.
2. Na tela de login, toque em **Criar conta de teste**.
3. Informe nome, e-mail e uma senha (12+ caracteres, maiúscula, número e caractere especial).
4. Você entra como administrador de um centro de distribuição de demonstração e já pode escanear paletes.

> O servidor gratuito "dorme" após 15 minutos sem uso. O primeiro acesso pode levar cerca de 1 minuto.

## Como funciona

- **App:** Flutter (web, Android e iOS).
- **API:** FastAPI (Python).
- **IA:** detector YOLOv8n + classificadores MobileNetV3 (presença, tipo PBR, dano e causa do dano), executados com ONNX Runtime.

## Hospedagem

Publicado no [Render](https://render.com) a partir deste repositório (`Dockerfile`).
O código-fonte do app e da API está em `bundle/` (arquivo compactado dividido em partes).
