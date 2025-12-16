//
//  ContentView.swift
//  DenisVoice
//
//  UI principal de la app de voz para iPad Pro
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var voiceManager = VoiceManager()
    @StateObject private var conversationManager = ConversationManager()
    @State private var isRecording = false
    @State private var currentTranscription = ""
    @State private var denisResponse = ""
    @State private var isAuthenticated = false
    @State private var showSettings = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                         startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {

                // Header
                HStack {
                    Text("🎤 Denis AI Voice")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Spacer()

                    Button(action: { showSettings.toggle() }) {
                        Image(systemName: "gear")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                // Authentication status
                if !isAuthenticated {
                    FaceIDAuthView(isAuthenticated: $isAuthenticated)
                } else {

                    // Voice recording area
                    VoiceRecordingView(
                        isRecording: $isRecording,
                        currentTranscription: $currentTranscription,
                        onStartRecording: startRecording,
                        onStopRecording: stopRecording
                    )

                    // Conversation area
                    ConversationView(
                        transcription: currentTranscription,
                        denisResponse: denisResponse,
                        conversationHistory: conversationManager.conversationHistory
                    )

                    // Control buttons
                    ControlButtonsView(
                        onClearConversation: clearConversation,
                        onChangeMode: changeConversationMode
                    )
                }
            }
            .padding()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            setupManagers()
        }
        .onReceive(voiceManager.$transcription) { transcription in
            currentTranscription = transcription
        }
        .onReceive(conversationManager.$denisResponse) { response in
            denisResponse = response
        }
    }

    private func setupManagers() {
        voiceManager.conversationManager = conversationManager
        conversationManager.voiceManager = voiceManager
    }

    private func startRecording() {
        voiceManager.startRecording()
        isRecording = true
    }

    private func stopRecording() {
        voiceManager.stopRecording()
        isRecording = false
    }

    private func clearConversation() {
        conversationManager.clearConversation()
        currentTranscription = ""
        denisResponse = ""
    }

    private func changeConversationMode() {
        // Cambiar modo de conversación
        conversationManager.changeMode(.express)
    }
}

struct FaceIDAuthView: View {
    @Binding var isAuthenticated: Bool
    @State private var isAuthenticating = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "faceid")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Autenticación Requerida")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Usa Face ID para acceder a Denis AI")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            if isAuthenticating {
                ProgressView("Autenticando...")
            } else {
                Button(action: authenticateWithFaceID) {
                    Text("Autenticar con Face ID")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(40)
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
    }

    private func authenticateWithFaceID() {
        isAuthenticating = true

        FaceIDManager.authenticateWithFaceID { success, error in
            DispatchQueue.main.async {
                isAuthenticating = false
                if success {
                    isAuthenticated = true
                } else {
                    print("Face ID authentication failed: \(error ?? "Unknown error")")
                }
            }
        }
    }
}

struct VoiceRecordingView: View {
    @Binding var isRecording: Bool
    @Binding var currentTranscription: String
    let onStartRecording: () -> Void
    let onStopRecording: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(isRecording ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
                    .frame(width: 150, height: 150)

                Circle()
                    .fill(isRecording ? Color.red : Color.blue)
                    .frame(width: 100, height: 100)
                    .scaleEffect(isRecording ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(), value: isRecording)

                Button(action: {
                    if isRecording {
                        onStopRecording()
                    } else {
                        onStartRecording()
                    }
                }) {
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
            }

            Text(isRecording ? "Escuchando..." : "Toca para hablar")
                .font(.title3)
                .foregroundColor(isRecording ? .red : .blue)

            if !currentTranscription.isEmpty {
                Text("\"\(currentTranscription)\"")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct ConversationView: View {
    let transcription: String
    let denisResponse: String
    let conversationHistory: [ConversationMessage]

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(conversationHistory) { message in
                    MessageBubble(message: message)
                }

                if !denisResponse.isEmpty {
                    MessageBubble(message: ConversationMessage(
                        id: UUID(),
                        text: denisResponse,
                        isFromDenis: true,
                        timestamp: Date()
                    ))
                }
            }
            .padding()
        }
        .frame(maxHeight: 300)
        .background(Color.white.opacity(0.5))
        .cornerRadius(15)
    }
}

struct MessageBubble: View {
    let message: ConversationMessage

    var body: some View {
        HStack {
            if message.isFromDenis {
                Spacer()
            }

            Text(message.text)
                .padding(12)
                .background(message.isFromDenis ? Color.blue.opacity(0.8) : Color.green.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(15)
                .frame(maxWidth: 280, alignment: message.isFromDenis ? .trailing : .leading)

            if !message.isFromDenis {
                Spacer()
            }
        }
    }
}

struct ControlButtonsView: View {
    let onClearConversation: () -> Void
    let onChangeMode: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Button(action: onClearConversation) {
                Label("Limpiar", systemImage: "trash")
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: onChangeMode) {
                Label("Modo", systemImage: "gear")
                    .padding()
                    .background(Color.orange.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\ .presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Conexión")) {
                    Text("Servidor: ws://192.168.1.100:8140")
                    Text("Versión: 1.0.0")
                }

                Section(header: Text("Audio")) {
                    Text("Duración chunk: 3.0s")
                    Text("Idiomas: es, en")
                }

                Section(header: Text("Acerca de")) {
                    Text("Denis AI iPad Voice App")
                    Text("Con procesamiento Neural Engine")
                }
            }
            .navigationTitle("Configuración")
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
