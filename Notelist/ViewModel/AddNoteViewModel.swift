//
//  AddNoteViewModel.swift
//  Notelist
//
//  Created by cao duc tin  on 8/1/25.
//

import Foundation
import RealmSwift

class AddNoteViewModel{
    var audioFiles: [URL] = [] // List of audio files
    var audioFilesTempt: [URL] = []
    private var FileAudioNameTempt:[String] = []
    var onFetchAudioFiles: (() -> Void)?
    
    var existingNote: NodeModelRealm?
    init(existingNote: NodeModelRealm?) {
        self.existingNote = existingNote
       // fetchAudioFiles()
       fetchAudioFilesByNoteID()
    }
    // Fetch các file audio theo NoteID
    func fetchAudioFilesByNoteID() {
        guard let existingNote = existingNote else { return }
        // Lấy đường dẫn đến thư mục Documents của ứng dụng
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        audioFiles.removeAll()

        for fileName in existingNote.audioFilePaths {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            audioFiles.append(fileURL)
        }
        
        onFetchAudioFiles?()
    }
    func fetchAudioFiles() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            audioFiles = files.filter { $0.pathExtension == "m4a" }
            onFetchAudioFiles?() // Notify the view controller to update the UI
        } catch {
            print("Failed to fetch audio files: \(error.localizedDescription)")
        }
    }
    func deleteAudioFile(at index: Int) {
        let audioFile = audioFiles[index]
        guard let existingNote = existingNote else { return }
        
        // Tìm vị trí của đường dẫn file trong danh sách audioFilePaths của Realm
        if let fileIndex = existingNote.audioFilePaths.firstIndex(of: audioFile.absoluteString) {
            do {
                let realm = try Realm()
                try realm.write {
                    existingNote.audioFilePaths.remove(at: fileIndex) // Xóa đường dẫn trong Realm
                }
                print("Complete to delete in Realm")
            } catch {
                print("Failed to delete audio file path in Realm: \(error.localizedDescription)")
            }
        }
        
        // Chuẩn hóa URL (nếu có ký tự dư thừa)
        let filePath = audioFile.absoluteString.replacingOccurrences(of: "file://", with: "")
        
        // Xóa file thực tế khỏi hệ thống tệp
        do {
            let fileURL = URL(fileURLWithPath: filePath) // Chuyển thành URL hợp lệ
            try FileManager.default.removeItem(at: fileURL)
            audioFiles.remove(at: index)
            onFetchAudioFiles?() // Cập nhật lại UI sau khi xóa
        } catch {
            print("Failed to delete audio file from file system: \(error.localizedDescription)")
        }
    }


    func AddFileNameTempt(_ fileName: String){
        FileAudioNameTempt.append(fileName)
    }
    
    func GetFileName(){
        print("this is url in the temp file")
        FileAudioNameTempt.map { url in
            print(url)
        }
    }
    
    func getAllURLs() -> [URL] {
        return audioFiles
    }
    
    func convertAudioFileURLsToStrings() -> [String] {
        return audioFilesTempt.map { $0.absoluteString }
    }
    
    func getAudioFileTemp() -> [String]{
        return FileAudioNameTempt
    }

}

