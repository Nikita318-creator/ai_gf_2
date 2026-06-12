import Foundation
import RealmSwift
import UIKit

// MARK: - Обновленная модель для Realm
class CachedVideo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var urlString: String
    @Persisted var videoName: String
    @Persisted var localFileName: String // Храним только имя файла на диске
    @Persisted var thumbnailData: Data?  // Картинку оставляем в базе, она легкая
}

class RemoteRealmVideoService {
    static let shared = RemoteRealmVideoService()
    private let realm: Realm
    
    // Директория для хранения видеофайлов (папка Caches)
    private var cachesDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    private init() {
        let config = Realm.Configuration(
            schemaVersion: SchemaVersion.currentSchemaVersion
        )

        do {
            self.realm = try Realm(configuration: config)
        } catch {
            let fallbackConfig = Realm.Configuration(inMemoryIdentifier: "CachedVideoFallbackRealm")
            self.realm = try! Realm(configuration: fallbackConfig)
        }
    }
    
    // MARK: - Save
    func saveVideo(urlString: String, name: String, data: Data) {
        // 1. Генерируем имя файла с правильным расширением
        let fileExtension = (urlString as NSString).pathExtension.isEmpty ? "mp4" : (urlString as NSString).pathExtension
        let localFileName = "\(UUID().uuidString).\(fileExtension)"
        let fileURL = cachesDirectory.appendingPathComponent(localFileName)
        
        // 2. Пишем видео-дату напрямую на диск
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("❌ Не удалось записать видеофайл на диск: \(error)")
            return
        }
        
        // 3. Делаем превью
        let thumbnailImage = data.generateVideoThumbnail()
        let thumbnailData = thumbnailImage?.jpegData(compressionQuality: 0.8)
        
        // 4. Пишем метаданные в Realm
        let video = CachedVideo()
        video.urlString = urlString
        video.videoName = name
        video.localFileName = localFileName
        video.thumbnailData = thumbnailData
        
        do {
            try realm.write {
                realm.add(video, update: .modified)
            }
        } catch {
            print("❌ Ошибка сохранения видео в Realm: \(error)")
            // Если база почему-то зафолбэчила или не записала, удаляем файл, чтобы не плодить мусор
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
    
    // MARK: - Read
    
    /// Возвращает локальный URL-путь к файлу для AVPlayer
    func getVideoLocalURL(name: String) -> URL? {
        guard let videoObject = realm.objects(CachedVideo.self).filter("videoName == %@", name).first else {
            return nil
        }
        
        // Если запись старая (еще без имени файла), просто выходим
        if videoObject.localFileName.isEmpty {
            return nil
        }
        
        let fileURL = cachesDirectory.appendingPathComponent(videoObject.localFileName)
        
        // Проверяем, существует ли файл физически (на случай очистки папки Caches системой)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        } else {
            // Файл удален системой — убираем «сиротскую» запись из базы
            try? realm.write {
                realm.delete(videoObject)
            }
            return nil
        }
    }
    
    func getThumbnailData(name: String) -> Data? {
        return realm.objects(CachedVideo.self)
            .filter("videoName == %@", name)
            .first?
            .thumbnailData
    }
    
    func isVideoCached(name: String) -> Bool {
        return getVideoLocalURL(name: name) != nil
    }
    
    func getAllVideos() -> [CachedVideo] {
        Array(realm.objects(CachedVideo.self))
    }
    
    // MARK: - Delete
    
    /// Удаляет и файл с диска, и запись из Realm
    func deleteVideo(name: String) {
        guard let videoObject = realm.objects(CachedVideo.self).filter("videoName == %@", name).first else {
            return
        }
        
        if !videoObject.localFileName.isEmpty {
            let fileURL = cachesDirectory.appendingPathComponent(videoObject.localFileName)
            try? FileManager.default.removeItem(at: fileURL)
        }
        
        do {
            try realm.write {
                realm.delete(videoObject)
            }
        } catch {
            print("❌ Ошибка удаления видео из Realm: \(error)")
        }
    }
}
