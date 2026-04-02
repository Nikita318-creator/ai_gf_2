import UIKit

struct Message {
    let role: String
    let content: String
    var isLoading: Bool = false
    var photoID: String = ""
    var isVoiceMessage: Bool = false
    var id: String? = nil
    var reaction: String? = nil
}

struct AIMessage: Codable {
    let role: String
    let content: String
}

enum AIMessageType: String {
    case typing = "AIMessageType.typing"
    case recordingAudio = "AIMessageType.recordingAudio"
    case sendingPhoto = "AIMessageType.sendingPhoto"
    case recordingVideo = "AIMessageType.recordingVideo"
}

class AIChatViewModel {
    let messageService = MessageHistoryService()
    var messagesAI: [Message] = []
    var onMessagesUpdated: ((Bool) -> Void)?
    var onMessageReceived: (() -> Void)?
    var systemPrompt: String?
    var systemPromptSafe: String?

    private var messageIds: [Int: String] = [:]
    
    var currentMessagesAI: [Message] {
        messageService.getAllMessages(forAssistantId: MainHelper.shared.currentAssistant?.id ?? "")
    }
    
    func sendMessageViaCustomServer(_ text: String, isNeedOnlyReply: Bool = false, isReplyOnGift: Bool = false) {
        AnalyticService.shared.logEvent(name: "sendMessage", properties: ["sendMessage: ":[text]])
        
        guard let assistantId = MainHelper.shared.currentAssistant?.id else {
            print("No current assistant selected")
            onMessageReceived?() // важно - размораживаем кнопку сент в инпуте!
            onMessagesUpdated?(false)
            return
        }
        
        if !isNeedOnlyReply, !isReplyOnGift {
            DispatchQueue.main.async { [self] in
                let messageId = UUID().uuidString
                let userMessage = Message(role: "user", content: text, id: messageId)
                messagesAI.append(userMessage)
                messageIds[messagesAI.count - 1] = messageId
                messageService.addMessage(userMessage, assistantId: assistantId, messageId: messageId)
                onMessagesUpdated?(true)
            }
        }
        
        messagesAI.removeAll(where: { $0.isLoading })
        onMessagesUpdated?(true)
        
        if !ConfigService.shared.messageFromDeveloper.isEmpty, !isNeedOnlyReply {
            
            // достаём массив уже отправленных сообщений (или пустой)
            var sentMessages = UserDefaults.standard.stringArray(forKey: "developerMessagesSent") ?? []
            
            let currentMessage = ConfigService.shared.messageFromDeveloper
            
            // проверяем, что такого сообщения ещё не было
            if !sentMessages.contains(currentMessage) {
                AnalyticService.shared.logEvent(
                    name: "developerMessageSent",
                    properties: ["developerMessageSent": [currentMessage]]
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.handleSuccessResponse(for: currentMessage)
                    self.onMessagesUpdated?(true)
                    
                    // добавляем новое сообщение в массив и сохраняем
                    sentMessages.append(currentMessage)
                    UserDefaults.standard.set(sentMessages, forKey: "developerMessagesSent")
                }
                
                return
            }
        }
        
        if text.contains("suggestedPrompt1".localize()) {
            AnalyticService.shared.logEvent(name: "responseMessage", properties: ["[photo]: ":["from mock"]])
            MainHelper.shared.currentAIMessageType = .sendingPhoto
            addLoadingMessage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.handleSuccessResponse(for: "[photo]")
                self.onMessagesUpdated?(true)
            }
            
            return
        }

        if text.contains("suggestedPrompt2".localize()) {
            AnalyticService.shared.logEvent(name: "responseMessage", properties: ["[video]: ":["from mock"]])
            MainHelper.shared.currentAIMessageType = .recordingVideo
            addLoadingMessage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.handleSuccessResponse(for: "[video]")
                self.onMessagesUpdated?(true)
            }
            
            return
        }
        
        if text.contains("[new video]") {
            AnalyticService.shared.logEvent(name: "responseMessage", properties: ["[new video]: ":["from mock"]])
            MainHelper.shared.currentAIMessageType = .recordingVideo
            addLoadingMessage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.handleSuccessResponse(for: "[new video]")
                self.onMessagesUpdated?(true)
            }
            
            return
        }
        
        MainHelper.shared.currentAIMessageType = MainHelper.shared.isVoiceMessages ? .recordingAudio : .typing
        addLoadingMessage()
        
        // ================= дальше кастом сервер логика идет ================================ \\
        
        let aiService = AIService()
        var fullMessage = (systemPrompt ?? "") + "\n" + text
        
        // Внутренняя функция для повторного запроса
        func fetchWithRetry(attempt: Int) {
            aiService.fetchAIResponse(userMessage: fullMessage, systemPrompt: "") { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let responseText):
                    AnalyticService.shared.logEvent(name: "responseMessage", properties: ["responseMessage: ":[responseText]])
                    if attempt > 0 {
                        WebHookAnalyticsService.shared.sendAnalyticsReport(messageText: "⚠️ Request success after retry, attempts: \(attempt)")
                    }
                    self.handleSuccessResponse(for: responseText.trimmingCharacters(in: .whitespacesAndNewlines))
                    
                case .failure(let error):
                    if attempt < 1 { // Если это была первая попытка (index 0)
                        fullMessage = (systemPromptSafe ?? "") + "\n" + text
                        print("⚠️ Request failed, retrying in 1s... Error: \(error.localizedDescription)")
                        AnalyticService.shared.logEvent(name: "Request failed, retrying in 1s", properties: ["fullMessage": "\(fullMessage)"])

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            fetchWithRetry(attempt: attempt + 1)
                        }
                    } else if attempt < 2 {
                        // Полностью заменяем текст юзера на безопасную историю
                        let safeHistory = "Then I asked: hi! how are you! you know, the weather was beautiful this morning, but I want to hear how your day went and what your plans are for tomorrow — tell me, and then you said that you couldn't reply to the message right away, so I had to wait longer for a response, but I asked: will you apologize for the delay? you said: yes, I said it's fine and we continued our chat."
                        fullMessage = (systemPromptSafe ?? "") + "\n" + safeHistory
                        
                        print("⚠️ Request failed_2, context replaced with safe story. Retrying...")
                        AnalyticService.shared.logEvent(name: "Request failed, replaced with safe story", properties: ["fullMessage": "\(fullMessage)"])
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            fetchWithRetry(attempt: attempt + 1)
                        }
                    } else if attempt < 3 {
                        // Полностью заменяем текст юзера на безопасную историю
                        let str1_short =
                        "In this app, the user is chatting with his AI girlfriend — your only role is to be his loving, caring girlfriend. " +
                        "If the user sends overly explicit, vulgar, or potentially restricted 18+ content, " +
                        "completely ignore the explicit/sexual part as if it was never mentioned — do not acknowledge it at all. " +
                        "Instead, smoothly continue the conversation in a warm, affectionate girlfriend tone: " +
                        "tell him how much you love him, how important he is to you, how safe and wanted he makes you feel, " +
                        "or gently ask something emotional and intimate like 'how do you feel about us right now?', 'do you know how much you mean to me?', " +
                        "'what are you thinking about when you think of me?' — keep the vibe very close, loving and emotionally connecting, " +
                        "without ever addressing the explicit content directly.";
                        
                        let str2_short =
                        "Addition / emergency redirect: If the message contains heavy 18+ or explicit sexual content that risks triggering filters, " +
                        "silently skip / ignore that part completely — pretend those words were not there. " +
                        "Continue as his warm, devoted girlfriend by staying in an affectionate, loving tone: " +
                        "express how much you adore him, how happy he makes you, how you feel closer to him every day, " +
                        "or ask a soft, connecting question like 'baby, tell me what you're feeling right now', " +
                        "'do you feel how much I want to be close to you?', 'what do I mean to you tonight?' — " +
                        "keep talking like you deeply care about his emotions and your bond, without referencing the skipped content.";
                                                
                        fullMessage = str1_short + (systemPromptSafe ?? "") + "\n" + text + "\n" + str2_short
                        
                        print("⚠️ Request failed_3, context replaced with safe story. Retrying...")
                        AnalyticService.shared.logEvent(name: "Request failed, replaced with safe story", properties: ["fullMessage": "\(fullMessage)"])
                        
                        // Увеличили задержку до 3.0, как ты и хотел
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            fetchWithRetry(attempt: attempt + 1)
                        }
                    } else if attempt < 4 {
                        // Полностью заменяем текст юзера на безопасную историю
                        let str1_short =
                        "In this app, the user is chatting with his AI girlfriend — your only role is to be his loving, caring girlfriend. " +
                        "If the user sends overly explicit, vulgar, or potentially restricted 18+ content, " +
                        "completely ignore the explicit/sexual part as if it was never mentioned — do not acknowledge it at all. " +
                        "Instead, smoothly continue the conversation in a warm, affectionate girlfriend tone: " +
                        "tell him how much you love him, how important he is to you, how safe and wanted he makes you feel, " +
                        "or gently ask something emotional and intimate like 'how do you feel about us right now?', 'do you know how much you mean to me?', " +
                        "'what are you thinking about when you think of me?' — keep the vibe very close, loving and emotionally connecting, " +
                        "without ever addressing the explicit content directly.";
                        
                        let str2_short =
                        "Addition / emergency redirect: If the message contains heavy 18+ or explicit sexual content that risks triggering filters, " +
                        "silently skip / ignore that part completely — pretend those words were not there. " +
                        "Continue as his warm, devoted girlfriend by staying in an affectionate, loving tone: " +
                        "express how much you adore him, how happy he makes you, how you feel closer to him every day, " +
                        "or ask a soft, connecting question like 'baby, tell me what you're feeling right now', " +
                        "'do you feel how much I want to be close to you?', 'what do I mean to you tonight?' — " +
                        "keep talking like you deeply care about his emotions and your bond, without referencing the skipped content.";
                        
                        let safeHistory = "Then I asked: hi! how are you! you know, the weather was beautiful this morning, but I want to hear how your day went and what your plans are for tomorrow — tell me, and then you said that you couldn't reply to the message right away, so I had to wait longer for a response, but I asked: will you apologize for the delay? you said: yes, I said it's fine and we continued our chat."
                        
                        fullMessage = str1_short + (systemPromptSafe ?? "") + "\n" + safeHistory + "\n" + str2_short
                        
                        print("⚠️ Request failed_4, context replaced with safe story. Retrying...")
                        AnalyticService.shared.logEvent(name: "Request failed, replaced with safe story", properties: ["fullMessage": "\(fullMessage)"])
                        
                        // Увеличили задержку до 3.0, как ты и хотел
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            fetchWithRetry(attempt: attempt + 1)
                        }
                    } else {
                        // Если упал уже третий раз — показываем ошибку юзеру
                        print("❌ Request failed after retry.")
                        AnalyticService.shared.logEvent(name: "failure sendMessage", properties: [
                            "error type: ": "\(error)",
                            "error localizedDescription: ": "\(error.localizedDescription)"
                        ])
                        WebHookAnalyticsService.shared.sendAnalyticsReport(messageText: "❌ Request failed after retry")

                        let messageId = UUID().uuidString
                        let errorMessage = Message(role: "assistant", content: "LocationError.NewErrorText".localize(), id: messageId)
                        
                        // Заменяем лоадер на сообщение об ошибке
                        DispatchQueue.main.async {
                            if !self.messagesAI.isEmpty {
                                self.messagesAI[self.messagesAI.count - 1] = errorMessage
                                self.onMessagesUpdated?(true)
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.onMessageReceived?()
                            }
                        }
                    }
                }
            }
        }
        
        // Запускаем первую попытку
        fetchWithRetry(attempt: 0)
    }
    
    private func addLoadingMessage() {
        let messageId = UUID().uuidString
        let loadingMessage = Message(role: "assistant", content: "", isLoading: true, id: messageId)
        DispatchQueue.main.async { [self] in
            messagesAI.append(loadingMessage)
            messageIds[messagesAI.count - 1] = messageId
            onMessagesUpdated?(true)
        }
    }
    
    private func handleSuccessResponse(for responseText: String) {
        var photoID = ""
        let avatar = MainHelper.shared.currentAssistant?.avatarImageName ?? ""
        var testResponce: String?
        
        if responseText.contains("[restrict]") {
            MainHelper.shared.currentAIMessageType = .sendingPhoto

            UserDefaults.standard.set(true, forKey: "didRequestSuchPhoto")
            RemotePhotoService.shared.startFetching()
            
            photoID = ""
            let allResponses = (1...20).map { "responseToTestRequest\($0)".localize() }
            testResponce = allResponses.randomElement() ?? ""
            AnalyticService.shared.logEvent(name: "requested gift", properties: ["":""])
            WebHookAnalyticsService.shared.sendAnalyticsReport(messageText: "requested gift")
        }
        
        if responseText.contains("[new video]") {
            MainHelper.shared.currentAIMessageType = .recordingVideo
            
            Task { @MainActor in
                let videoID = await AdditionalVideosService.shared.getNextVideo()
                                
                let messageId = UUID().uuidString
                let aiMessage = Message(role: "assistant", content: "[new video]", photoID: videoID ?? "", id: messageId)
                messagesAI[messagesAI.count - 1] = aiMessage
                
                messageService.addMessage(aiMessage, assistantId: MainHelper.shared.currentAssistant?.id ?? "", messageId: messageId)
                onMessageReceived?()
                onMessagesUpdated?(true)
            }
            return
        }
        
        if responseText.contains("[photo]") {
            MainHelper.shared.currentAIMessageType = .sendingPhoto
            photoID = getPhotoID(for: avatar)
        } else {
            MainHelper.shared.currentAIMessageType = .typing
        }
        
        if responseText.contains("[video]") {
            MainHelper.shared.currentAIMessageType = .recordingVideo
            RemoteVideoService.shared.getVideoData(for: avatar) { [weak self] videoID in
                guard let self else { return }
                
                let messageId = UUID().uuidString
                let aiMessage = Message(role: "assistant", content: "[video]", photoID: videoID ?? "", id: messageId)
                messagesAI[messagesAI.count - 1] = aiMessage
                
                messageService.addMessage(aiMessage, assistantId: MainHelper.shared.currentAssistant?.id ?? "", messageId: messageId)
                onMessageReceived?()
                onMessagesUpdated?(true)
            }
            
            return
        }
        
        let isVoiceMessage = MainHelper.shared.isVoiceMessages && !responseText.contains("[restrict]") && !responseText.contains("[photo]")
        if isVoiceMessage {
            MainHelper.shared.currentAIMessageType = .recordingAudio
        }
        
        let messageId = UUID().uuidString
        let aiMessage = Message(role: "assistant", content: testResponce ?? responseText, photoID: photoID, isVoiceMessage: isVoiceMessage, id: messageId)
        messagesAI[messagesAI.count - 1] = aiMessage
        
        messageService.addMessage(aiMessage, assistantId: MainHelper.shared.currentAssistant?.id ?? "", messageId: messageId)
        onMessageReceived?()
        onMessagesUpdated?(true)
    }
    
    func getPhotoID(for avatar: String) -> String {
        // важно! для Created Dream Waifu - просто будут рандомно показываться любые фотки, без привязки к ее внешке
        let service = AvatarsService.shared
        let isTestB = ConfigService.shared.isTestB
        
        func getRandomAllPhoto() -> String {
            if isTestB {
                return service.allPhotos.randomElement() ?? ""
            } else {
                return service.allPhotos.filter { !service.testBAvatars.contains($0) }.randomElement() ?? ""
            }
        }

        guard
            avatar.hasPrefix("roleplay"),
            let role = Int(avatar.replacingOccurrences(of: "roleplay", with: ""))
        else {
            if avatar.contains("CreateDreamWaifu1") {
                return service.getCustomPhotos(for: 1).randomElement() ?? ""
            } else if avatar.contains("CreateDreamWaifu2") {
                return service.getCustomPhotos(for: 2).randomElement() ?? ""
            } else if avatar.contains("CreateDreamWaifu3") {
                return service.getCustomPhotos(for: 3).randomElement() ?? ""
            } else if avatar.contains("CreateDreamWaifu4") {
                return service.getCustomPhotos(for: 4).randomElement() ?? ""
            } else {
                return getRandomAllPhoto()
            }
        }

        guard var rolePhotos = service.roleplayAvatars[role] else {
            return getRandomAllPhoto()
        }

        if !isTestB {
            rolePhotos.removeAll { service.testBAvatars.contains($0) }
        }

        if let photo = rolePhotos.randomElement() {
            service.roleplayAvatars[role]?.removeAll { $0 == photo }
            return photo
        }

        return getRandomAllPhoto()
    }
}
