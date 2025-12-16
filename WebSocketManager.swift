//
//  WebSocketManager.swift
//  DenisVoice
//
//  Gestión de WebSocket para comunicación en tiempo real con Denis AI
//

import Foundation
import Starscream

class WebSocketManager: WebSocketDelegate {
    private var socket: WebSocket!
    private var isConnected = false

    var onTranscriptionReceived: ((String) -> Void)?
    var onResponseReceived: (([String: Any]) -> Void)?
    var onConnectionStatusChanged: ((Bool) -> Void)?

    private let serverURL = "ws://192.168.1.100:8140"  // Cambiar por IP del servidor

    init() {
        setupWebSocket()
    }

    private func setupWebSocket() {
        guard let url = URL(string: serverURL) else {
            print("Invalid WebSocket URL")
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 30

        socket = WebSocket(request: request)
        socket.delegate = self
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func sendAudioChunk(_ audioData: Data, isFinal: Bool) {
        guard isConnected else {
            print("WebSocket not connected")
            return
        }

        // Convertir audio a base64
        let base64Audio = audioData.base64EncodedString()

        let message: [String: Any] = [
            "type": "voice_chunk",
            "audio_data": base64Audio,
            "is_final": isFinal,
            "language": "es",
            "sequence": Int(Date().timeIntervalSince1970)
        ]

        sendMessage(message)
    }

    func sendTextMessage(_ text: String) {
        let message: [String: Any] = [
            "type": "text_message",
            "text": text
        ]

        sendMessage(message)
    }

    func authenticateWithFaceID(_ faceIDData: String) {
        let message: [String: Any] = [
            "type": "face_id_auth",
            "user_id": UIDevice.current.identifierForVendor?.uuidString ?? "unknown",
            "face_id_data": faceIDData
        ]

        sendMessage(message)
    }

    private func sendMessage(_ message: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: message),
              let jsonString = String(data: data, encoding: .utf8) else {
            return
        }

        socket.write(string: jsonString)
    }

    // MARK: - WebSocketDelegate

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("WebSocket connected")
            isConnected = true
            onConnectionStatusChanged?(true)

        case .disconnected(let reason, let code):
            print("WebSocket disconnected: \(reason)")
            isConnected = false
            onConnectionStatusChanged?(false)

        case .text(let text):
            handleReceivedMessage(text)

        case .error(let error):
            print("WebSocket error: \(error?.localizedDescription ?? "Unknown error")")
            isConnected = false
            onConnectionStatusChanged?(false)

        default:
            break
        }
    }

    private func handleReceivedMessage(_ text: String) {
        guard let data = text.data(using: .utf8),
              let message = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let type = message["type"] as? String else {
            return
        }

        switch type {
        case "handshake":
            print("Handshake received from Denis AI")

        case "auth_success":
            print("Face ID authentication successful")

        case "auth_failed":
            print("Face ID authentication failed")

        case "transcription_partial":
            if let transcription = message["text"] as? String {
                onTranscriptionReceived?(transcription)
            }

        case "response_complete":
            onResponseReceived?(message)

        case "error":
            if let errorMsg = message["message"] as? String {
                print("Server error: \(errorMsg)")
            }

        default:
            print("Unknown message type: \(type)")
        }
    }
}
