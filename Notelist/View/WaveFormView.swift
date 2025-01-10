//
//  WaveFormView.swift
//  Notelist
//
//  Created by cao duc tin  on 7/1/25.
//

import UIKit
class WaveformView: UIView {
    
    private var wavePoints: [CGFloat] = []
    private let maxWavePoints = 100
    private let barWidth: CGFloat = 2.0
    private let barSpacing: CGFloat = 1.0

      override func draw(_ rect: CGRect) {
          guard let context = UIGraphicsGetCurrentContext() else { return }
          context.setFillColor(UIColor.red.cgColor)
          // Draw the previous wave if there was no update, otherwise, only draw the new bars
          let startIndex = wavePoints.count > maxWavePoints ? wavePoints.count - maxWavePoints : 0

          for (i, point) in wavePoints[startIndex..<wavePoints.count].enumerated() {
              let barHeight = point * rect.height // Scale height based on the power level
              let xPosition = CGFloat(i) * (barWidth + barSpacing)
              let yPosition = (rect.height - barHeight)/2
              let barRect = CGRect(x: xPosition, y: yPosition, width: barWidth, height: barHeight)
              context.fill(barRect)
          }
          
          if wavePoints.count > maxWavePoints {
              let removedBars = wavePoints.count - maxWavePoints
              for i in 0..<removedBars {
                  let barHeight = wavePoints[i] * rect.height
                  let xPosition = CGFloat(i) * (barWidth + barSpacing)
                  let yPosition = (rect.height - barHeight)/2
                  let barRect = CGRect(x: xPosition, y: yPosition, width: barWidth, height: barHeight)
                  context.clear(barRect)
              }
          }
      }
    func update(withLevel level: CGFloat) {
        let normalizedLevel = max(0, min(1, level))
        wavePoints.append(normalizedLevel)
        if wavePoints.count > maxWavePoints {
            wavePoints.removeFirst()
        }

        setNeedsDisplay()
    }
}
