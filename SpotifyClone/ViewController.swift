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
        setupAudioPlayer()
        updatePlayButtonImage()
                
        musicProgressBar.progress = 0.0
        TimerView.text = formatarTempo(segundosTotais: 0)
        
    }
    

    @IBAction func Play(_ sender: Any) {
        isPaused.toggle()
               updatePlayButtonImage()

               if isPaused {
                   audioPlayer?.pause()
                   stopAllTimers()
               } else {
                   audioPlayer?.play()
                   startAllTimers()
               }
           }

    func updatePlayButtonImage() {
        if isPaused {
            PlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        } else {
            PlayButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
    }

    func setupAudioPlayer() {
        guard let url = Bundle.main.url(forResource: "niggas", withExtension: "mp3") else {
                   print("Não foi possível encontrar o arquivo de áudio.")
            PlayButton.isEnabled = false
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
                   
            if let player = audioPlayer {
                TotalTimer.text = formatarTempo(segundosTotais: Float(player.duration))
            } else {
                       TotalTimer.text = "0:00"
            }

        } catch {
            print("Erro ao inicializar o player de áudio: \(error.localizedDescription)")
            PlayButton.isEnabled = false
        }
    }

           // MARK: - Gerenciamento de Timers

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

           // MARK: - Atualização da UI

           @objc func updateProgressBar() {
               guard let player = audioPlayer else { return }

               
               musicProgressBar.progress = Float(player.currentTime / player.duration)
               
               
               if player.currentTime >= player.duration {
                   resetPlayerState()
               }
           }
           
           @objc func updateCurrentTimeDisplay() {
               guard let player = audioPlayer else { return }
               
               TimerView.text = formatarTempo(segundosTotais: Float(player.currentTime))
           }
           
           // MARK: - Formatação de Tempo

           func formatarTempo(segundosTotais: Float) -> String {
               let minutos = Int(segundosTotais) / 60
               let segundos = Int(segundosTotais) % 60

               return String(format: "%d:%02d", minutos, segundos)
           }
           
           // MARK: - Resetar Estado do Player

           func resetPlayerState() {
               stopAllTimers()
               isPaused = true
               updatePlayButtonImage()
               
               musicProgressBar.progress = 0.0
               TimerView.text = formatarTempo(segundosTotais: 0)
               
               audioPlayer?.currentTime = 0.0
           }
       }

       // MARK: - Extensão para AVAudioPlayerDelegate
       extension ViewController: AVAudioPlayerDelegate {
           func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
               if flag {
                   resetPlayerState()
               }
           }
       }
