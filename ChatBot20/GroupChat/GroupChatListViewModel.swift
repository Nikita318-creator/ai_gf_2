//
//  GroupChatListViewModel.swift
//  ChatBot20
//
//  Created by Mikita on 05/06/2026.
//

import Foundation
import UIKit

class GroupChatListViewModel {
    
    var chats: [ChatModel] = [] {
        didSet {
            onChatsUpdated?()
        }
    }

    var onChatsUpdated: (() -> Void)?

    let assistantsService = AssistantsService()
    let messageHistoryService = MessageHistoryService()
    
    init() {
//        assistantsService.getAllConfigs().forEach {
//            if $0.id?.contains("_group") == true {
//                assistantsService.deleteConfig(id: $0.id ?? "")
//            }
//        } // это пока тесчу не трггай потом выпилю удалялку
        setupGroupChats()
        loadGroupChats()
    }
    
    func loadGroupChats() {
        chats = assistantsService.getAllConfigs().compactMap { config in
            guard config.id?.contains("_group") == true else {
                return nil
            }

            let lastMessage = messageHistoryService.getAllMessages(
                forAssistantId: config.id ?? ""
            ).last?.content ?? config.expertise.rawValue.localize()
            
            return ChatModel(
                id: config.id ?? "",
                assistantName: config.assistantName,
                lastMessage: lastMessage,
                lastMessageTime: "",
                assistantAvatar: config.avatarImageName,
                isUnread: false
            )
        }
    }
    
    func chat(at indexPath: IndexPath) -> ChatModel {
        return chats[indexPath.row]
    }
    
    private func setupGroupChats() {
        guard !assistantsService.getAllConfigs().contains(where: {
            $0.id?.contains("_group") == true
        }) else { return }
        
        struct GroupPreset {
            let idSuffix: String
            let name: String
            let info: String
            let avatar: String
            let initialMessage: String
            let avatarName: String
        }
        
        let presets: [GroupPreset] = [
            GroupPreset(
                idSuffix: "volleyball_group",
                name: "Volleyball Club 🏐",
                info: "Group chat of the female volleyball team. The user is the only male manager. Young women are athletic, competitive, and highly supportive of the manager.",
                avatar: "groupChat5",
                initialMessage: "***Rem*** Hey manager! Are you coming to training today? We need you to stats our spikes! 😏",
                avatarName: "roleplay9_14"
            ),
            GroupPreset(
                idSuffix: "summercamp_group",
                name: "Summer Camp 🌲",
                info: "Summer camp camp counselors/campers secret chat. Late night vibes, playful, romantic, adventurous.",
                avatar: "groupChat4",
                initialMessage: "***Rin*** Psst... is the camp chief asleep? We are planning to sneak out to the lake, who is with us?",
                avatarName: "roleplay8_16"
            ),
            GroupPreset(
                idSuffix: "roommates_group",
                name: "Roommates (Floor 3) 🏠",
                info: "Shared apartment / dorm group chat. Casual, dramatic, cozy, full of daily life teasing.",
                avatar: "groupChat3",
                initialMessage: "***Saber*** Who left their hoodie in the living room? It smells nice though... haha",
                avatarName: "roleplay10_8"
            ),
            GroupPreset(
                idSuffix: "office_group",
                name: "Office Coffee Break ☕",
                info: "Secret office chat without the boss. Female colleagues flirting and slacking off with the user.",
                avatar: "groupChat2",
                initialMessage: "***Yuno*** The presentation is so boring. Let's grab coffee? Our favorite desk is empty~",
                avatarName: "roleplay12_4"
            ),
            GroupPreset(
                idSuffix: "council_group",
                name: "Student Council 🏛️",
                info: "High school student council chat. High status young women, teasing the user, tsundere and kuudere dynamics.",
                avatar: "groupChat1",
                initialMessage: "***Emilia*** Prez! You forgot to sign the budget papers again. Come to the council room right now!",
                avatarName: "roleplay8_2"
            )
        ]
        
        for preset in presets {
            let groupID = preset.idSuffix
            
            let groupConfig = AssistantConfig(
                id: groupID,
                assistantName: preset.name,
                expertise: .roleplay,
                assistantInfo: preset.info,
                userInfo: "A guy surrounded by beautiful anime young women in this group.",
                avatarImageName: preset.avatar
            )
            
            assistantsService.addConfig(groupConfig)
            
            let messageId = UUID().uuidString
            MessageHistoryService().addMessage(
                Message(
                    role: "assistant",
                    content: preset.initialMessage,
                    id: messageId,
                    avatarName: preset.avatarName
                ),
                assistantId: groupID,
                messageId: messageId
            )
        }
    }
}
