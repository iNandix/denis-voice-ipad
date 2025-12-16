//
//  VoiceManager.swift
//  DenisVoice
//
//  Gestión de voz con Neural Engine del iPad Pro
//

import Foundation
import AVFoundation
import Combine
import Accelerate

class VoiceManager: ObservableObject {
    @Published var isRecording = false
    @Published var transcription = ""
    @Published var audioLevel: Float = 0.0

    private var audioEngine: AVAudioEngine!
    private var audioProcessor: AudioProcessor!
    private var webSocketManager: WebSocketManager!
    var conversationManager: ConversationManager?

    private var audioChunks: [Data] = []
    private let chunkDuration: TimeInterval = 3.0
    private var recordingStartTime: Date?

    init() {
        setupAudio()
        setupWebSocket()
    }

    private func setupAudio() {
        audioEngine = AVAudioEngine()
        audioProcessor = AudioProcessor()

        // Configurar input node
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)

        // Configurar procesamiento de audio
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { [weak self] buffer, time in
            self?.processAudioBuffer(buffer, time: time)
        }
    }

    private func setupWebSocket() {
        webSocketManager = WebSocketManager()
        webSocketManager.onTranscriptionReceived = { [weak self] text in
            DispatchQueue.main.async {
                self?.transcription = text
            }
        }

        webSocketManager.onResponseReceived = { [weak self] response in
            DispatchQueue.main.async {
                self?.conversationManager?.handleDenisResponse(response)
            }
        }
    }

    func startRecording() {
        guard !isRecording else { return }

        do {
            audioChunks.removeAll()
            recordingStartTime = Date()

            try audioEngine.start()
            isRecording = true

            print("🎤 Started recording with Neural Engine")

        } catch {
            print("Error starting recording: \(error)")
        }
    }

    func stopRecording() {
        guard isRecording else { return }

        audioEngine.stop()
        isRecording = false

        // Procesar último chunk
        processFinalChunk()

        print("🛑 Stopped recording")
    }

    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer, time: AVAudioTime) {
        guard isRecording else { return }

        // Convertir buffer a Data
        let audioData = audioBufferToData(buffer)

        // Añadir a chunks actuales
        audioChunks.append(audioData)

        // Actualizar nivel de audio
        updateAudioLevel(buffer)

        // Verificar si es tiempo de enviar chunk
        if let startTime = recordingStartTime,
           Date().timeIntervalSince(startTime) >= chunkDuration {

            sendAudioChunk(isFinal: false)
            audioChunks.removeAll()
            recordingStartTime = Date()
        }
    }

    private func processFinalChunk() {
        guard !audioChunks.isEmpty else { return }

        sendAudioChunk(isFinal: true)
        audioChunks.removeAll()
    }

    private func sendAudioChunk(isFinal: Bool) {
        let combinedData = audioChunks.reduce(Data()) { $0 + $1 }

        // Comprimir con Neural Engine si disponible
        let compressedData = audioProcessor.compressAudio(combinedData)

        // Enviar via WebSocket
        webSocketManager.sendAudioChunk(compressedData, isFinal: isFinal)
    }

    private func audioBufferToData(_ buffer: AVAudioPCMBuffer) -> Data {
        let channelCount = Int(buffer.format.channelCount)
        let frameLength = Int(buffer.frameLength)
        let stride = buffer.stride

        var data = Data()

        if let floatChannelData = buffer.floatChannelData {
            for frame in 0..<frameLength {
                for channel in 0..<channelCount {
                    let sample = floatChannelData[channel][frame * stride]
                    withUnsafeBytes(of: sample) { data.append(contentsOf: $0) }
                }
            }
        }

        return data
    }

    private func updateAudioLevel(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }

        let frameLength = Int(buffer.frameLength)
        var sum: Float = 0

        for i in 0..<frameLength {
            sum += channelData[i] * channelData[i]
        }

        let rms = sqrt(sum / Float(frameLength))
        DispatchQueue.main.async {
            self.audioLevel = rms
        }
    }
}
