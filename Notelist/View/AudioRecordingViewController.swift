import UIKit
import AVFoundation

class AudioRecordingViewController: UIViewController {
    
    
    var recordingWaveView: WaveformView!
    private let viewModel = AudioRecorderController()
    var onCompleteRecording:(()->())?
    var onFinishRecording: ((String) -> Void)?
    
    
    @IBOutlet weak var MicrophoneUIView: UIImageView!
    @IBOutlet weak var WaveSoundUIView: UIView!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGradientBackground()
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
        if let parentBackgroundColor = self.WaveSoundUIView.backgroundColor {
               recordingWaveView.backgroundColor = parentBackgroundColor
           }
        self.WaveSoundUIView.addSubview(recordingWaveView)
        self.WaveSoundUIView.addSubview(recordingWaveView)
        MicrophoneUIView.image = UIImage(systemName: "mic.fill")
         MicrophoneUIView.tintColor = .gray
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
        if isMovingFromParent {
            stopRecording()
        }
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
            let normalizedPower = CGFloat((decibel + 40) / 40)
            print("this is decibel\(decibel)")
            print("this is normalizedPower\(normalizedPower)")
            self.recordingWaveView.update(withLevel: normalizedPower)
        }
    }
    func setupGradientBackground() {
           let gradientLayer = CAGradientLayer()
           
           // Set the gradient colors
           gradientLayer.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor] // Start and end colors
           
           // Set the direction of the gradient
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
           // Apply the gradient to the view's background
           gradientLayer.frame = view.bounds
           view.layer.insertSublayer(gradientLayer, at: 0)
       }
}

