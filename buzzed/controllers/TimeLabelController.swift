//
//  TimeLabelController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import Foundation
import UIKit

class TimeLabelController: UISlider {
    private var timeLabel: UILabel = UILabel()

    private var labelFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }

    private lazy var labelView: UIView = {
        let thumb = UIView()
        return thumb
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        timeLabel.frame = CGRect(x: labelFrame.origin.x, y: labelFrame.maxY - 60, width: labelFrame.size.width, height: 30)
        self.setValue()
    }

    private func setValue() {
        timeLabel.text = String(Int(self.value))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(timeLabel)
        timeLabel.textAlignment = .center
        timeLabel.layer.zPosition = layer.zPosition + 1
        timeLabel.adjustsFontSizeToFitWidth = true
    }
}
