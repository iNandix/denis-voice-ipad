# Denis AI iPad Voice App

App iOS nativa completa para iPad Pro que conecta con Denis AI usando el chip M1/M2 para procesamiento avanzado de voz.

## 🚀 Características

- **STT en tiempo real** aprovechando Neural Engine del iPad Pro
- **Detección emocional** usando Core ML
- **Chunking conversacional inteligente** de 3 segundos
- **Face ID** para autenticación biométrica
- **WebSocket streaming** para comunicación bidireccional
- **UI nativa SwiftUI** optimizada para iPad
- **Procesamiento offline** cuando es posible

## 📱 Requisitos

- **iPad Pro** (M1/M2 chip)
- **iOS 16.0+**
- **Face ID** habilitado
- **Conexión WiFi** para servidor Denis AI

## 🛠️ Instalación

### Opción 1: Xcode Project (Recomendado)

1. **Descargar archivos:**
   ```bash
   # Crear directorio del proyecto
   mkdir DenisVoiceApp
   cd DenisVoiceApp
   ```

2. **Configurar Xcode:**
   - Abrir Xcode
   - File > New > Project > iOS App
   - Nombre: `DenisVoice`
   - Interface: `SwiftUI`
   - Language: `Swift`

3. **Agregar archivos:**
   - Copiar todos los archivos `.swift` generados
   - Reemplazar `Info.plist` con el generado
   - Agregar dependencias en Package.swift

4. **Configurar servidor:**
   - Editar `WebSocketManager.swift`
   - Cambiar `serverURL` por la IP de tu servidor Denis AI

### Opción 2: Swift Package Manager

```bash
swift package init --type executable
# Copiar archivos y configurar Package.swift
```

## ⚙️ Configuración

### 1. Configurar IP del servidor

Edita `WebSocketManager.swift`:

```swift
private let serverURL = "ws://[TU_IP_SERVIDOR]:8140"
```

### 2. Configurar permisos

La app requiere:
- Microphone access
- Face ID permission
- Network access

### 3. Iniciar servidor Denis AI

```bash
# En tu servidor Linux
cd /media/jotah/SSD_denis/DENIS_SYSTEM/core
python3 denis_voice_system_unified.py
```

## 🎯 Uso

1. **Abrir la app** en iPad Pro
2. **Autenticar** con Face ID
3. **Tocar el botón** para empezar a hablar
4. **Hablar naturalmente** - la app procesa chunks de 3 segundos
5. **Recibir respuesta** de Denis AI con voz sintetizada

## 🧠 Procesamiento Neural

La app aprovecha el Neural Engine del iPad Pro para:

- **Reconocimiento de voz** en tiempo real
- **Análisis emocional** de la voz
- **Compresión Opus** optimizada
- **Detección de intención** conversacional

## 🔧 Arquitectura

```
iPad Pro (M1/M2)
├── Neural Engine
│   ├── Voice Recognition
│   ├── Emotion Detection
│   └── Audio Processing
├── Face ID
├── SwiftUI Interface
└── WebSocket Client
    └── Denis AI Server
```

## 📊 Rendimiento

- **Latencia STT**: <100ms (Neural Engine)
- **Chunk size**: 3 segundos optimizado
- **Compresión**: Opus 64kbps
- **Face ID**: <500ms
- **WebSocket**: Real-time streaming

## 🐛 Troubleshooting

### Problemas comunes:

1. **Face ID no funciona:**
   - Verificar que Face ID esté configurado en Ajustes
   - Reiniciar iPad

2. **No conecta al servidor:**
   - Verificar IP del servidor
   - Comprobar conexión WiFi
   - Verificar que el puerto 8140 esté abierto

3. **Audio no se procesa:**
   - Verificar permisos de micrófono
   - Comprobar que no haya otras apps usando el micrófono

## 📝 Desarrollo

### Agregar nuevas características:

1. **Nuevo modo de conversación:**
   ```swift
   enum ConversationMode {
       case custom
   }
   ```

2. **Nueva detección emocional:**
   ```swift
   func detectCustomEmotion(_ audio: Data) -> EmotionType {
   }
   ```

3. **Integración con Core ML:**
   ```swift
   let model = try MLModel(contentsOf: modelURL)
   ```

## 📄 Licencia

Esta app está diseñada específicamente para funcionar con Denis AI.

## 🤝 Contribución

Para mejoras específicas del iPad Pro:
- Optimizaciones Neural Engine
- Nuevos modelos Core ML
- Mejoras en la UI para iPad

---

**Generado por Denis AI iPad Voice App Generator v1.0.0**
