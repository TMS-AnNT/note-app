//
//  WaveFormView.swift
//  Notelist
//
//  Created by cao duc tin  on 7/1/25.
//

import UIKit
class WaveformView: UIView {
    
    private var wavePoints: [CGFloat] = []
    private let maxWavePoints = 50 // Adjust the number of bars displayed
    private let barWidth: CGFloat = 4.0 // Width of each bar
    private let barSpacing: CGFloat = 2.0 // Spacing between bars
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Clear the previous waveform
        context.clear(rect)
        
        // Set the bar color
        context.setFillColor(UIColor.red.cgColor)
        
        // Calculate the width of each bar and draw them
        for (i, point) in wavePoints.enumerated() {
            let barHeight = point * rect.height // Scale height based on the power level
            let xPosition = CGFloat(i) * (barWidth + barSpacing)
            let yPosition = rect.height - barHeight
            let barRect = CGRect(x: xPosition, y: yPosition, width: barWidth, height: barHeight)
            context.fill(barRect)
        }
    }
    
    // Update the waveform with new audio level
    func update(withLevel level: CGFloat) {
        let normalizedLevel = max(0, min(1, level)) // Clamp the level between 0 and 1
        wavePoints.append(normalizedLevel)
        if wavePoints.count > maxWavePoints {
            wavePoints.removeFirst()
        }
        print("this is wavePoints\(wavePoints)")
        // Redraw the waveform
        setNeedsDisplay()
    }
}
