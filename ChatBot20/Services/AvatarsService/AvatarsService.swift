import UIKit

final class AvatarsService {
    static let shared = AvatarsService()
    private init() {}

    private let rolesWithExtendedPhotos: Set<Int> = [4]
    private let rolesWith10Photos: Set<Int> = [10]

    // 1. Описываем группы (связи между ID)
    private let roleGroups: [[Int]] = [
        [1, 5],
        [2, 12],
        [3, 8, 10],
        [4],
        [6, 11],
        [7, 9]
    ]

    // 2. Генерация базовых фото (как они лежат в ассетах)
    private var rawAvatars: [Int: [String]] {
        Dictionary(uniqueKeysWithValues: (1...12).map { role in
            let count = rolesWithExtendedPhotos.contains(role) ? 30 : (rolesWith10Photos.contains(role) ? 10 : 20)
            return (role, (1...count).map { "roleplay\(role)_\($0)" })
        })
    }

    // 3. Финальный словарь: теперь для 1 и 5 массивы будут идентичны и полны
    lazy var roleplayAvatars: [Int: [String]] = {
        var merged: [Int: [String]] = [:]
        let base = rawAvatars
        
        for group in roleGroups {
            // Собираем все фото для всех участников группы в один массив
            let combinedPhotos = group.flatMap { base[$0] ?? [] }
            // Назначаем этот полный массив каждому участнику группы
            for roleId in group {
                merged[roleId] = combinedPhotos
            }
        }
        return merged
    }()

    lazy var allPhotos: [String] = {
        // Берем только уникальные фото из всех групп, чтобы не было дублей
        Set(roleplayAvatars.values.flatMap { $0 }).sorted()
    }()

    lazy var testBAvatars: Set<String> = {
        let manualPhotos: Set<String> = [
            "roleplay4_7", "roleplay4_9", "roleplay6_4", "roleplay6_9",
            "roleplay7_6", "roleplay7_10", "roleplay8_6", "roleplay10_9",
            "roleplay5_3",
        ]
        
        // Автоматически добавляем все новые фото (11-20)
        let newPhotos = allPhotos.filter { photo in
            guard let lastPart = photo.split(separator: "_").last,
                  let index = Int(lastPart) else { return false }
            return index >= 11
        }
        
        return manualPhotos.union(newPhotos)
    }()
}

extension AvatarsService {
    
    // 4. Логика для кастомных аватарок (createdByUser_X)
    // Генерируем по 10 фоток для каждого из 4-х ID
    var userCreatedAvatars: [Int: [String]] {
        var dict: [Int: [String]] = [:]
        for id in 1...4 {
            // Формат: createdByUser_1_1, createdByUser_1_2 ... createdByUser_1_10
            let photos = (1...10).map { "createdByUser_\(id)_\($0)" }
            dict[id] = photos
        }
        return dict
    }
    
    // Вспомогательная функция, чтобы дергать фотки по ID для кастомных аи-шек
    func getCustomPhotos(for id: Int) -> [String] {
        return userCreatedAvatars[id] ?? []
    }
}
