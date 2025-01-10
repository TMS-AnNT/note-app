import UIKit
import AVFoundation

class AudioRecordingViewController: UIViewController {
    
    
    var recordingWaveView: WaveformView!
    private let viewModel = AudioRecorderController()
    var onCompleteRecording:(()->())?
    var onFinishRecording: ((String) -> Void)?
    
    
    @IBOutlet weak var WaveSoundUIView: UIView!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.delegate = self
    }
    
    @IBAction func btnRecordAction(_ sender: Any) {
        toggleRecording()
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
        let imageName = viewModel.isRecording ? "stop.circle.fill" : "play.fill"
        RecordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func stopRecording() {
        viewModel.stopRecording()
        navigationController?.popViewController(animated: true)
        self.onCompleteRecording?()
    }
    private func toggleRecording() {
        if viewModel.isRecording {
            stopRecording()
        } else {
            viewModel.startRecording()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

extension AudioRecordingViewController: AudioRecorderDelegate{
    func didFinishRecording(fileName: String) {
        self.onFinishRecording?(fileName)
    }
    
    func didUpdateElapsedTime(_ time: String) {
        TimerLabel.text = time
    }
    
    
    func didStartRecording() {
        print("start record")
        updateRecordButtonImage(isRecording: true)
    }
    
    func didStopRecording() {
        print("Stop record")
        updateRecordButtonImage(isRecording: false)
    }
    
    func didUpdateDecibelLevel(decibel: Float) {
        DispatchQueue.main.async {
            let normalizedPower = CGFloat((decibel + 160) / 160)
            self.recordingWaveView.update(withLevel: normalizedPower)
        }
    }
    //MARK: this function is get url from viewModel and pass it parentView
//    func didFinishRecording() {
//        self.onFinishRecording?(audioFileURL)
//    }
}

