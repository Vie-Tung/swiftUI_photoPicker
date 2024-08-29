//
//  CameraPermission.swift
//  Camera Photo
//
//  Created by Tung Viet on 29/08/2024.
//

import AVFoundation
import UIKit

enum CameraPermission {
    enum CameraError: Error, LocalizedError {
        case unauthorized
        case unavailable

        var errorDescription: String? {
            switch self {
            case .unauthorized:
                return NSLocalizedString("You have not authorized camera use", comment: "")
            case .unavailable:
                return NSLocalizedString("A camera is not available", comment: "")
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .unavailable:
                return "Use the photo album instead."
            case .unauthorized:
                return "Open Settings > Privacy and Security > Camera and turn on for this app."
            }
        }
    }

    static func checkPermissions() -> CameraError? {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

            switch authStatus {
            case .notDetermined:
                return nil
            case .restricted:
                return nil
            case .denied:
                return .unauthorized
            case .authorized:
                return nil
            }
        } else {
            return .unavailable
        }
    }
}
