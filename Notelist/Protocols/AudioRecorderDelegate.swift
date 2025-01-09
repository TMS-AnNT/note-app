//
//  AudioRecorderDelegate.swift
//  Notelist
//
//  Created by cao duc tin  on 9/1/25.
//

import UIKit

@objc protocol AudioRecorderDelegate: AnyObject {
    func didStartRecording()
    func didStopRecording()
    func didUpdateDecibelLevel( decibel: Float)
     func didUpdateElapsedTime(_ time: String)
    @objc optional func didFinishRecording(audioFileURL: URL)
}
