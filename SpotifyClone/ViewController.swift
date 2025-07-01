import UIKit
import AVFoundation

class ViewController: UIViewController {


    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var musicProgressBar: UIProgressView!
    @IBOutlet weak var TimerView: UILabel!
    @IBOutlet weak var TotalTimer: UILabel!
    
    var isPaused = true
    var audioPlayer: AVAudioPlayer?
    var progressBarTimer: Timer?
    var displayTimer: Timer?

    override func viewDidLoad() {
           super.viewDidLoad()
           
           AudioManager.shared.setupPlayerIfNeeded()
           updatePlayButtonImage()
           
           TimerView.text = formatarTempo(segundosTotais: Float(AudioManager.shared.getCurrentTime()))
           TotalTimer.text = formatarTempo(segundosTotais: Float(AudioManager.shared.getDuration()))
           musicProgressBar.progress = Float(AudioManager.shared.getCurrentTime() / AudioManager.shared.getDuration())
           
           if AudioManager.shared.isPlaying() {
               startAllTimers()
           }
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
            let imageName = AudioManager.shared.isPaused ? "play.circle.fill" : "pause.circle.fill"
            PlayButton.setImage(UIImage(systemName: imageName), for: .normal)
        }

        func startAllTimers() {
            stopAllTimers()
            progressBarTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
            displayTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCurrentTimeDisplay), userInfo: nil, repeats: true)
        }

        func stopAllTimers() {
            progressBarTimer?.invalidate()
            progressBarTimer = nil
            displayTimer?.invalidate()
            displayTimer = nil
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
                TimerView.text = formatarTempo(segundosTotais: 0)
            }
        }

        @objc func updateCurrentTimeDisplay() {
            TimerView.text = formatarTempo(segundosTotais: Float(AudioManager.shared.getCurrentTime()))
        }

        func formatarTempo(segundosTotais: Float) -> String {
            let minutos = Int(segundosTotais) / 60
            let segundos = Int(segundosTotais) % 60
            return String(format: "%d:%02d", minutos, segundos)
        }
    }
