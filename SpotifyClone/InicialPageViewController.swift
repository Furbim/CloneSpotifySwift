//
//  InicialPageViewController.swift
//  SpotifyClone
//
//  Created by COTEMIG on 01/07/25.
//

import Foundation
import UIKit

class InicialPageViewController: UIViewController {

    @IBOutlet weak var musicProgressBar: UIProgressView!
    @IBOutlet weak var PlayButton: UIButton!
    
    var progressBarTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AudioManager.shared.setupPlayerIfNeeded()

        musicProgressBar.progress = Float(AudioManager.shared.getCurrentTime() / AudioManager.shared.getDuration())

        if AudioManager.shared.isPlaying() {
            startAllTimers()
        }

        updatePlayButtonImage()
    }
    @IBAction func Play(_ sender: Any) {
        
        AudioManager.shared.togglePlayPause()
                updatePlayButtonImage()
                
                if AudioManager.shared.isPaused {
                    stopAllTimers()
                } else {
                    startAllTimers()
                }
        
    }
    
    func updatePlayButtonImage() {
            let imageName = AudioManager.shared.isPaused ? "play.fill" : "pause.fill"
            PlayButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    
    func startAllTimers() {
        stopAllTimers()
        progressBarTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
       
    }

    
    func stopAllTimers() {
        progressBarTimer?.invalidate()
        progressBarTimer = nil
    }

    @objc func updateProgressBar() {
        let current = AudioManager.shared.getCurrentTime()
        let total = AudioManager.shared.getDuration()
        musicProgressBar.progress = Float(current / total)

        if current >= total {
            AudioManager.shared.reset()
            updatePlayButtonImage()
            stopAllTimers()
            musicProgressBar.progress = 0
        }
    }

}
