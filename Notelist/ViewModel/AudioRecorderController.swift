//
//  AudioRecorderController.swift
//  Notelist
//
//  Created by cao duc tin  on 8/1/25.
//

import UIKit
import RealmSwift
import UIKit
import AVFoundation

class AudioRecorderController: NSObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var time: Timer?
    var decibelLevel: Float = 0.0
    private var elapsedTime: Int = 0
    var tickCount:Int = 0
    var fileName: String?
    private var audioFileURL: URL?
    
    var onDecibelUpdate: ((Float) -> Void)?
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    weak var delegate: AudioRecorderDelegate?
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            
            if self.audioFileURL == nil {
                fileName = "audio_\(UUID().uuidString).m4a"
                guard let fileName = fileName else { return }
                
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                self.audioFileURL = documentsPath.appendingPathComponent(fileName)
            }
            
            guard let fileURL = self.audioFileURL else {
                print("Failed to create file URL for recording.")
                return
            }
            
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatAppleLossless,
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey:
                    AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
            delegate?.didStartRecording()
            delegate?.didFinishRecording(fileName: fileName!)
            startMonitoringDecibels()
            
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        stopMonitoringDecibels()
        
        delegate?.didStopRecording()
        
    }
    private func startMonitoringDecibels() {
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.audioRecorder?.updateMeters()
            if let decibel = self.audioRecorder?.averagePower(forChannel: 0) {
                self.decibelLevel = decibel
                self.onDecibelUpdate?(decibel)//use closure
                
                self.delegate?.didUpdateDecibelLevel(decibel: decibel)
            }
            self.tickCount += 1
            
            // Mỗi 10 lần (0.1 * 10 = 1 giây), tăng elapsedTime
            if self.tickCount % 10 == 0 {
                self.elapsedTime += 1
                self.updateElapsedTimeDisplay()
                print("1 giây đã trôi qua")
            }
        }
    }
    
    private func updateElapsedTimeDisplay() {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        let formattedTime = String(format: "%02d:%02d", minutes, seconds)
        
        delegate?.didUpdateElapsedTime(formattedTime)
    }
    
    private func stopMonitoringDecibels() {
        timer?.invalidate()
        timer = nil
    }
    func getURl()-> URL?{
        return audioFileURL
    }
}
