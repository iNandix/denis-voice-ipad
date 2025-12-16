//
//  ConversationManager.swift
//  DenisVoice
//
//  Gestión de conversación con chunking inteligente
//

import Foundation
import Combine

struct ConversationMessage: Identifiable {
    let id: UUID
    let text: String
    let isFromDenis: Bool
    let timestamp: Date
    let emotion: EmotionType?
}

enum ConversationMode {
    case express    // Conversación rápida
    case deep       // Conversación profunda
    case command    // Solo comandos
}

class ConversationManager: ObservableObject {
    @Published var conversationHistory: [ConversationMessage] = []
    @Published var denisResponse: String = ""
    @Published var currentMode: ConversationMode = .express

    private var voiceManager: VoiceManager?
    private var emotionDetector = EmotionDetector()

    // Chunking inteligente
    private var conversationChunks: [[ConversationMessage]] = []
    private let maxChunkSize = 10
    private let chunkOverlap = 2

    func setVoiceManager(_ manager: VoiceManager) {
        voiceManager = manager
    }

    func addUserMessage(_ text: String) {
        let message = ConversationMessage(
            id: UUID(),
            text: text,
            isFromDenis: false,
            timestamp: Date(),
            emotion: nil  // Podría analizarse con NLP
        )

        conversationHistory.append(message)

        // Procesar chunking
        processConversationChunking()

        // Limitar historial
        if conversationHistory.count > 50 {
            conversationHistory.removeFirst(10)
        }
    }

    func handleDenisResponse(_ response: [String: Any]) {
        guard let text = response["text"] as? String else { return }

        let message = ConversationMessage(
            id: UUID(),
            text: text,
            isFromDenis: true,
            timestamp: Date(),
            emotion: analyzeResponseEmotion(text)
        )

        conversationHistory.append(message)
        denisResponse = text

        // Procesar respuesta de audio si está disponible
        if let audioBase64 = response["audio_data"] as? String,
           let audioData = Data(base64Encoded: audioBase64) {
            playAudioResponse(audioData)
        }
    }

    private func analyzeResponseEmotion(_ text: String) -> EmotionType? {
        // Análisis simple de emoción en respuesta de Denis
        let lowerText = text.lowercased()

        if lowerText.contains("encantado") || lowerText.contains("genial") {
            return .joy
        } else if lowerText.contains("entiendo") || lowerText.contains("claro") {
            return .neutral
        } else if lowerText.contains("preocup") || lowerText.contains("problema") {
            return .fear
        }

        return .neutral
    }

    private func playAudioResponse(_ audioData: Data) {
        // Reproducir respuesta de audio
        // Esto requiere integración con AVAudioPlayer
        print("🎵 Playing Denis audio response")
    }

    func changeMode(_ mode: ConversationMode) {
        currentMode = mode

        // Notificar cambio de modo
        let modeMessage = "Cambiando a modo \(modeDescription(mode))"
        denisResponse = modeMessage
    }

    private func modeDescription(_ mode: ConversationMode) -> String {
        switch mode {
        case .express: return "expres"
        case .deep: return "profundo"
        case .command: return "comandos"
        }
    }

    func clearConversation() {
        conversationHistory.removeAll()
        conversationChunks.removeAll()
        denisResponse = ""
    }

    // MARK: - Intelligent Chunking

    private func processConversationChunking() {
        guard !conversationHistory.isEmpty else { return }

        // Crear nuevo chunk
        let recentMessages = getRecentMessages(maxChunkSize)

        if conversationChunks.isEmpty || shouldCreateNewChunk(recentMessages) {
            conversationChunks.append(recentMessages)
        } else {
            // Actualizar último chunk
            conversationChunks[conversationChunks.count - 1] = recentMessages
        }

        // Limitar número de chunks
        if conversationChunks.count > 5 {
            conversationChunks.removeFirst()
        }

        // Analizar patrón de conversación
        analyzeConversationPattern()
    }

    private func getRecentMessages(_ count: Int) -> [ConversationMessage] {
        let startIndex = max(0, conversationHistory.count - count)
        return Array(conversationHistory[startIndex...])
    }

    private func shouldCreateNewChunk(_ messages: [ConversationMessage]) -> Bool {
        guard let lastChunk = conversationChunks.last else { return true }

        // Crear nuevo chunk si cambió el modo de conversación
        // o si hay un cambio significativo en el tema

        return messages.count >= maxChunkSize
    }

    private func analyzeConversationPattern() {
        guard conversationChunks.count >= 2 else { return }

        let currentChunk = conversationChunks.last!
        let previousChunk = conversationChunks[conversationChunks.count - 2]

        // Analizar cambios en el patrón
        let currentEmotion = analyzeChunkEmotion(currentChunk)
        let previousEmotion = analyzeChunkEmotion(previousChunk)

        // Ajustar modo de conversación basado en patrón
        adjustConversationModeBasedOnPattern(currentEmotion, previousEmotion)
    }

    private func analyzeChunkEmotion(_ chunk: [ConversationMessage]) -> EmotionType {
        // Análisis de emoción del chunk usando EmotionDetector
        let combinedText = chunk.map { $0.text }.joined(separator: " ")

        // Usar emotion detector para texto
        return emotionDetector.analyzeTextEmotion(combinedText).primaryEmotion
    }

    private func adjustConversationModeBasedOnPattern(_ current: EmotionType, _ previous: EmotionType) {
        // Ajustar modo basado en cambios emocionales
        if current == .anger && previous != .anger {
            // Cambiar a modo más calmado
            if currentMode == .express {
                changeMode(.deep)
            }
        } else if current == .joy && previous == .sadness {
            // Mantener modo positivo
            if currentMode == .command {
                changeMode(.express)
            }
        }
    }

    // MARK: - Context Management

    func getConversationContext() -> [String: Any] {
        return [
            "message_count": conversationHistory.count,
            "current_mode": currentModeDescription(),
            "last_message_time": conversationHistory.last?.timestamp.timeIntervalSince1970 ?? 0,
            "emotion_trend": analyzeEmotionTrend(),
            "conversation_chunks": conversationChunks.count
        ]
    }

    private func currentModeDescription() -> String {
        switch currentMode {
        case .express: return "express"
        case .deep: return "deep"
        case .command: return "command"
        }
    }

    private func analyzeEmotionTrend() -> String {
        guard conversationHistory.count >= 3 else { return "insufficient_data" }

        let recentMessages = getRecentMessages(5)
        let emotions = recentMessages.compactMap { $0.emotion }

        if emotions.count < 2 { return "neutral" }

        // Analizar tendencia
        let emotionCounts = Dictionary(grouping: emotions, by: { $0 })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }

        return emotionCounts.first?.key.rawValue ?? "mixed"
    }
}
