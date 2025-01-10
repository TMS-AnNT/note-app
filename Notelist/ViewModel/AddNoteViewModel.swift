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
    private var FileAudioNameTempt:[String] = []
    private var FileAudioNameUpdate: [String] = []
    var onFetchAudioFiles: (() -> Void)?
    
    var existingNote: NodeModelRealm?
    
    init(existingNote: NodeModelRealm?) {
        self.existingNote = existingNote
       // fetchAudioFiles()
        fetchAudioFilesByNoteID()
    }
    // MARK: Fetch các file audio theo NoteID
    func fetchAudioFilesByNoteID() {
        audioFiles.removeAll()
        
        FileAudioNameUpdate.removeAll()
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        for fileName in FileAudioNameTempt{
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            audioFiles.append(fileURL)
        }
        FileAudioNameUpdate.append( contentsOf: FileAudioNameTempt )
        
        guard let existingNote = existingNote else { return }
        FileAudioNameUpdate.append( contentsOf: existingNote.audioFilePaths )
        
        for fileName in existingNote.audioFilePaths {
            let fileURL = documentsDirectory.appendingPathComponent( fileName )
            audioFiles.append( fileURL )
            
        }
        onFetchAudioFiles?()
    }
    func fetchAudioFiles() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            audioFiles = files.filter { $0.pathExtension == "m4a" }
            onFetchAudioFiles?()
        } catch {
            print("Failed to fetch audio files: \(error.localizedDescription)")
        }
    }
    func deleteAudioFile(at index: Int) {
        let audioFile = audioFiles[index]
        print("this is audio file\(audioFile.lastPathComponent)")
        let fileName = audioFile.lastPathComponent
        guard let existingNote = existingNote else { return }
        
        if let fileIndex = existingNote.audioFilePaths.firstIndex(of: fileName) {
            do {
                let realm = try Realm()
                try realm.write {
                    // Remove the file reference from Realm
                    existingNote.audioFilePaths.remove(at: fileIndex)
                }
                print("Successfully deleted reference in Realm")
            } catch {
                print("Failed to delete audio file path in Realm: \(error.localizedDescription)")
            }
        }
        
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

    func deleteAllDuplicateAudioFiles() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        guard !FileAudioNameTempt.isEmpty else {
               print("FileAudioNameTempt is empty, no files to delete.")
               return
           }
        for fileName in FileAudioNameTempt {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            
        
            
            // Xóa file thực tế khỏi hệ thống tệp
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Successfully deleted file: \(fileName)")
            } catch {
                print("Failed to delete file from file system: \(error.localizedDescription)")
            }
        }
        
        audioFiles.removeAll { fileURL in
            FileAudioNameTempt.contains(fileURL.lastPathComponent)
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
    
    func getAudioFileTemp() -> [String]{
        return FileAudioNameTempt
    }
    func getFileNameToUpdate()->[String]{
        return FileAudioNameUpdate
    }
    
}

