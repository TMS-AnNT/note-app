//
//  AddNoteViewModel.swift
//  Notelist
//
//  Created by cao duc tin  on 8/1/25.
//

import Foundation

class AddNoteViewModel{
    var audioFiles: [URL] = [] // List of audio files
    var audioFilesTempt: [URL] = []
    var onFetchAudioFiles: (() -> Void)?
    
    var existingNote: NodeModelRealm?
    init(existingNote: NodeModelRealm?) {
            self.existingNote = existingNote
            fetchAudioFiles()
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
         do {
             try FileManager.default.removeItem(at: audioFile)
             audioFiles.remove(at: index)
             onFetchAudioFiles?() // Notify the view controller to update the UI
         } catch {
             print("Failed to delete audio file: \(error.localizedDescription)")
         }
     }
    
    func AddURLTemp(_ url: URL){
        audioFilesTempt.append(url)
    }
    
    func GetURlTempt(){
        audioFiles.map { url in
            print(url)
        }
    }
    
    func getAllURLs() -> [URL] {
        return audioFiles
    }

}

