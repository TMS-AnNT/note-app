//
//  AddNoteViewModel.swift
//  Notelist
//
//  Created by Cao Duc Tin on 7/1/25.
//

import UIKit
import AVFoundation
import RealmSwift

class AddNoteViewModel {
    
    // MARK: - Properties
    internal var audioRecorder: AVAudioRecorder?
    internal var audioFileURL: URL?
    var audioFiles: [URL] = [] // List of audio files
    var onFetchAudioFiles: (() -> Void)?
    
    var existingNote: NodeModelRealm?
    var onShowAlert: ((_ title: String, _ message: String) -> Void)?
    var temporaryRecordings: [String] = []
    
    // MARK: - Initializer
    
    
    init(existingNote: NodeModelRealm?) {
        self.existingNote = existingNote
        fetchAudioFiles()
    }
    
    // MARK: - Audio Management
    
    func fetchAudioFiles() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            audioFiles = files.filter { $0.pathExtension == "m4a" }
            onFetchAudioFiles?() // Notify the view controller to update the UI
        } catch {
            print("Failed to fetch audio files: \(error.localizedDescription)")
        }
    }
    func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            print("Audio session activated")
        } catch {
            print("Failed to activate audio session: \(error.localizedDescription)")
        }
    }
    func stopRecording() {
        guard let recorder = audioRecorder else {
            print("No active recording.")
            return
        }
        recorder.stop()
        // Không gán lại audioRecorder = nil để giữ lại recorder cũ
        print("Recording saved at: \(audioFileURL?.absoluteString ?? "No file URL")")
    }

    func startRecording() {
        checkMicrophonePermission { [weak self] granted in
            guard granted, let self = self else { return }
            
            self.setupAudioSession()

            // Kiểm tra nếu đã có file và tiếp tục ghi âm vào đó
            if self.audioRecorder == nil {
                // Tạo một file mới nếu chưa có
                let fileName = "audio_\(UUID().uuidString).m4a"
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                self.audioFileURL = documentsPath.appendingPathComponent(fileName)
            }
            
            guard let audioFileURL = self.audioFileURL else { return }
            self.temporaryRecordings.append(audioFileURL.path)

            // Audio settings for recording
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                if self.audioRecorder == nil {
                    self.audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
                    self.audioRecorder?.isMeteringEnabled = true
                }
                self.audioRecorder?.record() // Tiếp tục ghi âm vào file hiện tại
                print("Recording started.")
            } catch {
                print("Failed to start recording: \(error.localizedDescription)")
                self.onShowAlert?("Error", "Failed to start recording.")
            }
        }
    }

    
    func saveAudioFile(_ url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        
        do {
            try FileManager.default.moveItem(at: url, to: destinationURL)
            print("Audio file saved at: \(destinationURL.absoluteString)")
        } catch {
            print("Error saving audio file: \(error.localizedDescription)")
        }
    }
    
    func deleteAudioFile(at index: Int) {
        let audioFile = audioFiles[index]
        do {
            try FileManager.default.removeItem(at: audioFile)
            audioFiles.remove(at: index)
            onFetchAudioFiles?() // Notify the view controller to update the UI
        } catch {
            print("Failed to delete audio file: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Microphone Permission
    
    func checkMicrophonePermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion(true)
        case .denied:
            showPermissionDeniedAlert()
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    func showPermissionDeniedAlert() {
        onShowAlert?("Permission Denied", "Please enable microphone access in Settings.")
    }
    
    // MARK: - Note Management
    
 
}
