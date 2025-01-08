import UIKit
import AVFoundation

class AudioRecordingViewController: UIViewController {
    
    var recordingWaveView: WaveformView!
    var waveTimer: Timer?  // Timer for updating the waveform
       var timer: Timer?
    var viewModel: AddNoteViewModel!
    var elapsedTime: Int = 0
    @IBOutlet weak var WaveSoundUIView: UIView!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddNoteViewModel(existingNote: nil)
        viewModel.onFetchAudioFiles = { [weak self] in
            // Update UI when audio files are fetched
            self?.updateUI()
        }
        setupUI()
    }
    
    @IBAction func btnRecordAction(_ sender: Any) {
        if viewModel.audioRecorder?.isRecording == true {
                 stopRecording()
                 updateRecordButtonImage(isRecording: false)
             } else {
                 startRecording()
                 updateRecordButtonImage(isRecording: true)
             }
    }

    func setupUI() {
        recordingWaveView = WaveformView()

        // Set the frame to match the bounds of the parent view
        recordingWaveView.frame = self.WaveSoundUIView.bounds
        recordingWaveView.backgroundColor = .lightGray
        recordingWaveView.layer.cornerRadius = 8

        // Optionally, set autoresizing masks or constraints for resizing with the parent view
        recordingWaveView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.WaveSoundUIView.addSubview(recordingWaveView)

       }
    func updateRecordButtonImage(isRecording: Bool) {
         // Use system images for the button
         if isRecording {
             RecordButton.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
         } else {
             RecordButton.setImage(UIImage(systemName: "record.circle.fill"), for: .normal)
         }
     }
    @objc func startRecording() {
        viewModel.startRecording()
        animateRecordingWave()

    }
    
    func animateRecordingWave() {
        waveTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateWave), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateWave() {
        
        guard let recorder = viewModel.audioRecorder else { return }
        viewModel.audioRecorder?.isMeteringEnabled = true
        // Update meters to get the latest power level
        recorder.updateMeters()
        // Get the current power level from the audio recorder (normalized)
        let power = recorder.averagePower(forChannel: 0)
        let normalizedPower = CGFloat((power + 160) / 160) // Normalize power (-160 dB to 0 dB)
        print("Raw power value: \(power)")
        recordingWaveView.update(withLevel: normalizedPower)
    }
    
     func stopRecording() {
        viewModel.stopRecording()
         stopTimer()
         navigationController?.popViewController(animated: true)
    }
    
    
    // Update UI when the list of audio files is fetched
    func updateUI() {
        // You can implement any UI updates based on the fetched audio files (e.g., display file names)
    }
    
    // Save the file when the view disappears (user navigates back)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // If recording is ongoing, stop and save it
        if viewModel.audioRecorder?.isRecording == true {
            stopRecording()
        }
        
        // Save the audio file if required
        if let audioURL = viewModel.audioFileURL {
            viewModel.saveAudioFile(audioURL)
        }
    }
    
    
    func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600 // Calculate hours
        let minutes = (seconds % 3600) / 60 // Calculate minutes
        let secondsLeft = seconds % 60 // Calculate remaining seconds
        
        return String(format: "%02d:%02d:%02d", hours, minutes, secondsLeft) // Format as HH:MM:SS
    }

}


extension AudioRecordingViewController {
    func startTimer() {
          elapsedTime = 0 // Reset the time when starting
          timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
      }
      
      func stopTimer() {
          waveTimer?.invalidate()
          timer?.invalidate()
          timer = nil// Invalidate the timer when done
          waveTimer = nil
      }
      
      @objc func updateTimer() {
          elapsedTime += 1  // Increase the elapsed time by 1 second
          TimerLabel.text = formatTime(seconds: elapsedTime)  // Update the label with the formatted time
      }
}
