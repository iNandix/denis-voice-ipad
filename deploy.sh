#!/bin/bash

# Script de despliegue para Denis Voice iPad App

echo "🚀 Desplegando Denis Voice iPad App..."

# Verificar que tenemos un Mac disponible
if [ "$(uname)" != "Darwin" ]; then
    echo "⚠️ Este script debe ejecutarse en macOS"
    echo "Para Linux, usa los servicios de CI/CD en la nube"
    exit 1
fi

# Verificar Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode no está instalado"
    exit 1
fi

echo "📦 Construyendo app..."
xcodebuild build -project DenisVoice.xcodeproj -scheme DenisVoice -configuration Release -destination generic/platform=iOS

echo "📱 Creando archive..."
xcodebuild archive -project DenisVoice.xcodeproj -scheme DenisVoice -configuration Release -destination generic/platform=iOS -archivePath DenisVoice.xcarchive

echo "📤 Exportando IPA..."
xcodebuild -exportArchive -archivePath DenisVoice.xcarchive -exportOptionsPlist export_options.plist -exportPath ipa_output

echo "✅ IPA generado: ipa_output/DenisVoice.ipa"
echo ""
echo "📲 Para instalar en iPad:"
echo "1. Conecta iPad al Mac"
echo "2. Abre Finder y selecciona iPad"
echo "3. Arrastra el .ipa a la sección 'Apps'"
echo ""
echo "🎯 ¡Listo para usar!"
