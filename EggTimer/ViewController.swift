//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let softTime = 5
    let mediumTime = 7
    let hardtime = 12
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    let hardnessToTimeMap = [
        "Soft": 5,
        "Medium": 7,
        "Hard": 12
    ]
    
    var secondsRemaining = 1;
    let SECONDS_IN_MINUTE = 60
    var totalTime = 1;
    var timer = Timer()
    var player: AVAudioPlayer?
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        
        guard let hardness = sender.currentTitle else {
            print("Invalid button pressed")
            return
        }
        guard let time = hardnessToTimeMap[hardness] else {
            print("Invalid hardness selected - nothing in the dictionary corresponds to value")
            return
        }
        
        print("User Pressed: \(hardness). Recommended boil time is \(time) minutes.")
        
//        secondsRemaining = time*SECONDS_IN_MINUTE
        totalTime = time
        secondsRemaining = time
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func playAlarm() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func updateTimer(){
        progressView.progress = Float((totalTime - secondsRemaining)) / Float(totalTime)
        
        if secondsRemaining > 0 {
            print("\(secondsRemaining) seconds Reamining on countdown")
            secondsRemaining -= 1
        } else if secondsRemaining == 0 {
            timer.invalidate()
            playAlarm()
            self.titleLabel.text = "Done!"
        }
    }
    
}
