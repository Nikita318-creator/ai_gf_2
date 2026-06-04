import AVFoundation

class GoogleTTSManager: NSObject {
    static let shared = GoogleTTSManager()
    
    var audioPlayer: AVPlayer?
    private var apiKey: String {
        "AIzaSyAisC2WePRrTDojZa" + ConfigService.shared.audioHalfKey
    }

    var currentSpeakinID: String?
    private var isPreparing: Bool = false

    // Теперь UI сразу увидит, что процесс пошел
    var isSpeaking: Bool {
        if isPreparing {
            return true
        }
        return audioPlayer?.rate != 0 && audioPlayer?.error == nil && audioPlayer != nil
    }

    private override init() {
        super.init()
    }

    func speak(text: String) {
        stopSpeaking()
        
        isPreparing = true
        NotificationCenter.default.post(name: NSNotification.Name("updateAllAudioCellsOnStart"), object: nil)
        
        let rawLang = MainHelper.shared.currentLanguage.isEmpty ? (Locale.current.identifier) : MainHelper.shared.currentLanguage
        let voiceConfig = VoiceMapping.getConfig(for: rawLang)
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .spokenAudio, options: [])
        try? audioSession.setActive(true)
        
        guard let url = URL(string: "https://texttospeech.googleapis.com/v1/text:synthesize?key=\(apiKey)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let textToSpeech = text.replacingOccurrences(of: "~", with: "")
        
        // Динамически собираем audioConfig, чтобы не пихать pitch туда, где он запрещен
        var audioConfig: [String: Any] = [
            "audioEncoding": "MP3",
            "speakingRate": 1.05
        ]
        
        // Если pitch есть в конфиге (не nil) — добавляем его. Если это Journey (nil) — игнорируем.
        if let pitchValue = voiceConfig.pitch {
            audioConfig["pitch"] = pitchValue
        }
        
        let json: [String: Any] = [
            "input": ["text": textToSpeech],
            "voice": [
                "languageCode": voiceConfig.langTag,
                "name": voiceConfig.voiceName
            ],
            "audioConfig": audioConfig
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("❌ Ошибка сети: \(error?.localizedDescription ?? "no data")")
                WebHookAnalyticsService.shared.sendAnalyticsReport(messageText: "audio message error:\n \(error?.localizedDescription ?? "no data")")
                self?.handleError()
                return
            }
            
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let audioContent = jsonResponse["audioContent"] as? String,
                  let audioData = Data(base64Encoded: audioContent) else {
                print("❌ Google вернул ошибку: \(String(data: data, encoding: .utf8) ?? "")")
                WebHookAnalyticsService.shared.sendAnalyticsReport(messageText: "audio message JSON-error:\n \(String(data: data, encoding: .utf8) ?? "")")
                self?.handleError()
                return
            }
            
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("speech.mp3")
            try? audioData.write(to: tempURL)
            
            DispatchQueue.main.async {
                self?.isPreparing = false
                self?.play(url: tempURL)
            }
        }.resume()
    }

    // Доп. метод для сброса стейта при ошибке, чтобы ячейка не "висла"
    private func handleError() {
        DispatchQueue.main.async {
            self.isPreparing = false
            self.handleFinished()
        }
    }

    private func play(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
        
        // Дублируем нотификацию на случай, если за это время что-то сбросилось
        NotificationCenter.default.post(name: NSNotification.Name("updateAllAudioCellsOnStart"), object: nil)
    }

    func stopSpeaking(needNotifyOthers: Bool = true) {
        isPreparing = false
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        audioPlayer?.pause()
        audioPlayer = nil
        if needNotifyOthers {
            handleFinished()
        }
    }

    @objc private func playerDidFinishPlaying() {
        handleFinished()
    }
    
    private func handleFinished() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("updateAllAudioCellsOnFinish"), object: nil)
        }
    }
}
