import Foundation
import AVFoundation

class AudioManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioManager()
    
    var audioPlayer: AVAudioPlayer?
    var isPaused = true

    private override init() {
        super.init()
    }

    func setupPlayerIfNeeded() {
        guard audioPlayer == nil else { return }

        guard let url = Bundle.main.url(forResource: "niggas", withExtension: "mp3") else {
            print("Arquivo de áudio não encontrado")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        } catch {
            print("Erro ao inicializar player: \(error)")
        }
    }

    func play() {
        setupPlayerIfNeeded()
        isPaused = false
        audioPlayer?.play()
    }

    func pause() {
        isPaused = true
        audioPlayer?.pause()
    }

    func togglePlayPause() {
        if isPaused {
            play()
        } else {
            pause()
        }
    }

    func reset() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPaused = true
    }

    func getCurrentTime() -> TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }

    func getDuration() -> TimeInterval {
        return audioPlayer?.duration ?? 1 // evitar divisão por zero
    }

    func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
}
