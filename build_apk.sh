#!/bin/bash

# Script para gerar APK do aplicativo Controle de Estoque
# Este script deve ser executado em um ambiente com Android SDK configurado

echo "=== Build APK - Controle de Estoque ==="
echo ""

# Verificar se o Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter não encontrado. Instale o Flutter SDK primeiro."
    echo "   Visite: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Verificar se o Android SDK está configurado
echo "🔍 Verificando configuração do ambiente..."
flutter doctor

echo ""
echo "📦 Instalando dependências..."
flutter pub get

echo ""
echo "🔧 Limpando build anterior..."
flutter clean

echo ""
echo "📱 Gerando APK de release..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ APK gerado com sucesso!"
    echo "📍 Localização: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "📊 Informações do APK:"
    ls -lh build/app/outputs/flutter-apk/app-release.apk
    echo ""
    echo "🚀 Para instalar no dispositivo:"
    echo "   adb install build/app/outputs/flutter-apk/app-release.apk"
else
    echo ""
    echo "❌ Erro ao gerar APK. Verifique as mensagens acima."
    exit 1
fi

echo ""
echo "=== Build concluído ==="

