import UIKit
import AVFoundation

class ViewController: UIViewController {


    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var musicProgressBar: UIProgressView!
    @IBOutlet weak var musicProgressBar2: UIProgressView!
    
    var isPaused = true
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        updatePlayButtonImage()
        setupAudioPlayer()
        
        
        musicProgressBar.progress = 0.0
        musicProgressBar2.progress = 0.0
    }

    @IBAction func Play(_ sender: Any) {
        isPaused.toggle()
        updatePlayButtonImage()

        if isPaused {
            audioPlayer?.pause()
            stopProgressBarTimer()
        } else {
            audioPlayer?.play()
            startProgressBarTimer()
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
            // É uma boa prática desabilitar o botão se o áudio não for encontrado
            PlayButton.isEnabled = false
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self // Define o delegate para este ViewController
        } catch {
            print("Erro ao inicializar o player de áudio: \(error.localizedDescription)")
            // Desabilita o botão em caso de erro de inicialização
            PlayButton.isEnabled = false
        }
    }

    // MARK: - Funções do Timer da ProgressBar

    func startProgressBarTimer() {
        stopProgressBarTimer() // Invalida qualquer timer existente

        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
    }

    func stopProgressBarTimer() {
        timer?.invalidate() // Para o timer
        timer = nil // Libera o timer
    }

    @objc func updateProgressBar() {
        guard let player = audioPlayer else { return }

        let progress = Float(player.currentTime / player.duration)
        
        // Atualiza ambas as barras de progresso
        musicProgressBar.progress = progress
        musicProgressBar2.progress = progress // Adicionado: Atualiza a segunda barra

        if player.currentTime >= player.duration {
            stopProgressBarTimer()
            isPaused = true
            updatePlayButtonImage()
            
            // Reseta ambas as barras de progresso ao final
            musicProgressBar.progress = 0.0
            musicProgressBar2.progress = 0.0 // Adicionado: Reseta a segunda barra
            
            player.currentTime = 0.0 // Volta o áudio para o início
        }
    }
}

// MARK: - Extensão para AVAudioPlayerDelegate
extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag { // Se a música terminou com sucesso
            stopProgressBarTimer()
            isPaused = true
            updatePlayButtonImage()
            
            // Reseta ambas as barras de progresso ao final
            musicProgressBar.progress = 0.0
            musicProgressBar2.progress = 0.0 // Adicionado: Reseta a segunda barra
            
            player.currentTime = 0.0 // Reinicia o áudio para o começo
        }
    }
}
