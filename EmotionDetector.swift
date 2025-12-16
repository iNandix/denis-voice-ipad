//
//  EmotionDetector.swift
//  DenisVoice
//
//  Detección emocional usando Core ML y Neural Engine
//

import Foundation
import CoreML
import AVFoundation

class EmotionDetector {
    private var emotionModel: MLModel?
    private let audioProcessor = AudioProcessor()

    init() {
        loadEmotionModel()
    }

    private func loadEmotionModel() {
        // Cargar modelo Core ML para detección emocional
        // En producción, entrenar un modelo con datos de voz emocional
        do {
            // Intentar cargar modelo pre-entrenado
            if let modelURL = Bundle.main.url(forResource: "EmotionDetector", withExtension: "mlmodelc") {
                emotionModel = try MLModel(contentsOf: modelURL)
                print("✅ Emotion detection model loaded")
            } else {
                print("⚠️ Emotion model not found, using fallback detection")
            }
        } catch {
            print("Error loading emotion model: \(error)")
        }
    }

    func detectEmotion(from audioData: Data) -> EmotionResult {
        // Procesar audio con Neural Engine
        let audioFeatures = audioProcessor.processAudioWithNeuralEngine(audioData)

        if let model = emotionModel {
            // Usar modelo Core ML
            return detectWithModel(audioFeatures, model: model)
        } else {
            // Usar detección basada en reglas
            return detectWithRules(audioFeatures)
        }
    }

    private func detectWithModel(_ features: [String: Any], model: MLModel) -> EmotionResult {
        // Implementar predicción con Core ML
        // Esto requiere definir el input/output del modelo

        return EmotionResult(
            primaryEmotion: .neutral,
            confidence: 0.5,
            emotionScores: [:],
            features: features
        )
    }

    private func detectWithRules(_ features: [String: Any]) -> EmotionResult {
        // Detección emocional basada en reglas simples

        var emotionScores: [EmotionType: Float] = [
            .joy: 0.0,
            .sadness: 0.0,
            .anger: 0.0,
            .fear: 0.0,
            .surprise: 0.0,
            .neutral: 0.5
        ]

        // Analizar características de audio
        if let pitchVariability = features["pitch_variability"] as? Float {
            if pitchVariability > 0.8 {
                emotionScores[.joy] = 0.7
                emotionScores[.surprise] = 0.6
            }
        }

        if let energyContour = features["energy_contour"] as? Float {
            if energyContour > 0.8 {
                emotionScores[.anger] = 0.8
            } else if energyContour < 0.3 {
                emotionScores[.sadness] = 0.7
            }
        }

        if let speechRate = features["speech_rate"] as? Float {
            if speechRate > 0.9 {
                emotionScores[.fear] = 0.6
            }
        }

        // Encontrar emoción primaria
        let primaryEmotion = emotionScores.max { $0.value < $1.value }?.key ?? .neutral
        let confidence = emotionScores[primaryEmotion] ?? 0.0

        return EmotionResult(
            primaryEmotion: primaryEmotion,
            confidence: confidence,
            emotionScores: emotionScores,
            features: features
        )
    }

    func analyzeConversationEmotion(_ conversationHistory: [ConversationMessage]) -> ConversationEmotion {
        // Analizar emoción a lo largo de la conversación

        var emotionTrends: [EmotionType: [Float]] = [:]
        var overallSentiment: Float = 0.0

        for message in conversationHistory {
            if message.isFromDenis {
                // Analizar respuesta de Denis
                let emotion = analyzeTextEmotion(message.text)
                overallSentiment += emotion.sentimentScore
            }
        }

        let averageSentiment = overallSentiment / Float(max(conversationHistory.count, 1))

        return ConversationEmotion(
            overallSentiment: averageSentiment,
            emotionTrends: emotionTrends,
            conversationFlow: analyzeConversationFlow(conversationHistory)
        )
    }

    private func analyzeTextEmotion(_ text: String) -> TextEmotion {
        // Análisis emocional simple de texto
        let lowerText = text.lowercased()

        var sentimentScore: Float = 0.0

        // Palabras positivas
        let positiveWords = ["bien", "excelente", "perfecto", "genial", "fantástico", "ayudar", "claro"]
        for word in positiveWords {
            if lowerText.contains(word) {
                sentimentScore += 0.2
            }
        }

        // Palabras negativas
        let negativeWords = ["mal", "error", "problema", "no", "incorrecto", "fallo", "difícil"]
        for word in negativeWords {
            if lowerText.contains(word) {
                sentimentScore -= 0.2
            }
        }

        return TextEmotion(sentimentScore: max(-1.0, min(1.0, sentimentScore)))
    }

    private func analyzeConversationFlow(_ messages: [ConversationMessage]) -> ConversationFlow {
        // Analizar flujo de la conversación
        let messageCount = messages.count
        let responseTimeAverage = 2.0  // segundos promedio
        let engagementLevel = messageCount > 5 ? 0.8 : 0.4

        return ConversationFlow(
            messageCount: messageCount,
            averageResponseTime: responseTimeAverage,
            engagementLevel: engagementLevel,
            conversationLength: messages.last?.timestamp.timeIntervalSince(messages.first?.timestamp ?? Date()) ?? 0
        )
    }
}

// MARK: - Data Structures

enum EmotionType: String, Codable {
    case joy = "joy"
    case sadness = "sadness"
    case anger = "anger"
    case fear = "fear"
    case surprise = "surprise"
    case neutral = "neutral"
}

struct EmotionResult {
    let primaryEmotion: EmotionType
    let confidence: Float
    let emotionScores: [EmotionType: Float]
    let features: [String: Any]
}

struct TextEmotion {
    let sentimentScore: Float
}

struct ConversationEmotion {
    let overallSentiment: Float
    let emotionTrends: [EmotionType: [Float]]
    let conversationFlow: ConversationFlow
}

struct ConversationFlow {
    let messageCount: Int
    let averageResponseTime: TimeInterval
    let engagementLevel: Float
    let conversationLength: TimeInterval
}
