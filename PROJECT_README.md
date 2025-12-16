# Denis Voice iPad App

## 🚀 Inicio Rápido

### Opción 1: Xcode Local (Requiere Mac)
1. Abre `DenisVoice.xcodeproj` en Xcode
2. Conecta tu iPad Pro 3
3. Selecciona iPad como destino
4. Build & Run (⌘R)

### Opción 2: CI/CD en la Nube
1. Sube este código a GitHub
2. Configura Codemagic o GitHub Actions
3. Descarga el IPA generado
4. Instala en iPad usando Finder/iTunes

## ⚙️ Configuración

### IP del Servidor
Edita `WebSocketManager.swift` línea 22:
```swift
private let serverURL = "ws://[TU_IP_LINUX]:8140"
```

### Inicio del Servidor
```bash
cd /media/jotah/SSD_denis/DENIS_SYSTEM/core
python3 denis_voice_system_unified.py
```

## 🎯 Características

- ✅ STT en tiempo real con Neural Engine
- ✅ Detección emocional con Core ML
- ✅ Chunking conversacional de 3 segundos
- ✅ Face ID para autenticación
- ✅ Voz "tristan" configurada
- ✅ UI SwiftUI nativa para iPad

## 📱 Uso

1. Abre la app en iPad
2. Autentícate con Face ID
3. Toca el botón para hablar
4. Habla naturalmente con Denis AI

¡Tu iPad Pro 3 ahora es el dispositivo de voz principal de Denis AI! 🎤📱
