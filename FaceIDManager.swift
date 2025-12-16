//
//  FaceIDManager.swift
//  DenisVoice
//
//  Gestión de autenticación Face ID
//

import Foundation
import LocalAuthentication

class FaceIDManager {
    static func authenticateWithFaceID(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Verificar si Face ID está disponible
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false, error?.localizedDescription ?? "Face ID not available")
            return
        }

        // Verificar que sea Face ID (no Touch ID)
        guard context.biometryType == .faceID else {
            completion(false, "Face ID required")
            return
        }

        let reason = "Autenticación requerida para acceder a Denis AI"

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                             localizedReason: reason) { success, error in
            if success {
                completion(true, nil)
            } else {
                let errorMsg = error?.localizedDescription ?? "Authentication failed"
                completion(false, errorMsg)
            }
        }
    }

    static func getFaceIDStatus() -> (available: Bool, type: String) {
        let context = LAContext()
        var error: NSError?

        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)

        var biometryType = "none"
        if canEvaluate {
            switch context.biometryType {
            case .faceID:
                biometryType = "faceID"
            case .touchID:
                biometryType = "touchID"
            case .opticID:
                biometryType = "opticID"
            default:
                biometryType = "unknown"
            }
        }

        return (canEvaluate, biometryType)
    }
}
