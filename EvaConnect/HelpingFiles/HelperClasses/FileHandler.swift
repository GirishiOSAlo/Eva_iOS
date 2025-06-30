//
//  FileHandler.swift
//  ySkolar
//
//  Created by Sajad on 9/17/18.
//  Copyright © 2018 AAA. All rights reserved.
//

import Foundation
struct FileHandler {
    
    static let tempDirectory = "upload"
    var userDataDirectory: String? {
        do {
            let dataDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("data")
            
            var isDir : ObjCBool = false
            FileManager.default.fileExists(atPath: dataDirectoryPath, isDirectory: &isDir)
            
            if isDir.boolValue {
                return dataDirectoryPath
            }
            
            try FileManager.default.createDirectory(
                at: URL(fileURLWithPath: dataDirectoryPath),
                withIntermediateDirectories: true,
                attributes: nil)
            
            return dataDirectoryPath
            
        } catch {
            print("Creating 'data' directory failed. Error: \(error)")
            return nil
        }
    }
    
    static func createTempDirectory() -> Bool {
        do {
            try FileManager.default.createDirectory(
                at: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("upload"),
                withIntermediateDirectories: true,
                attributes: nil)
            return true
        } catch {
            print("Creating 'upload' directory failed. Error: \(error)")
            return false
        }
    }
    
    static func createTempMedia(with data: Data, format: Media.Format) -> Media? {
        //print("uploading image data size = \(data.len)")
        let fileExtension = format.rawValue
        
        let fileName = ProcessInfo.processInfo.globallyUniqueString + fileExtension
        
        var isDir : ObjCBool = false
        FileManager.default.fileExists(atPath: NSTemporaryDirectory().appending(tempDirectory), isDirectory: &isDir)
        
        if !isDir.boolValue,
            FileHandler.createTempDirectory() {
            //print("failed to create temp media")
           // return nil
        }
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tempDirectory).appendingPathComponent(fileName)
        
        do {
            try data.write(to: URL(fileURLWithPath: fileURL.path), options: [.atomic])
            print("temp data (\(format.rawValue)) written to \(fileURL.path)")
            
            switch format {
            case .MOV:
                return Media(name: fileName, type: Media.SourceType.video(fileURL))
            case .jpg, .png:
                return Media(name: fileName, type: Media.SourceType.image(fileURL))
            }
        } catch let error {
            print(error)
            return nil
        }
    }
    
    static func removeTempMedia(_ media: Media) -> Bool {
        let url: URL
        switch media.type {
        case .image(let imageUrl):
            url = imageUrl
        case .video(let videoUrl):
            url = videoUrl
        }
        do {
            try FileManager.default.removeItem(at: url)
            print("temp file removed at \(url)")
            return true
        } catch let error {
            print("fail to remove temp file at \(error)")
            return false
        }
    }
}


struct Media {
    enum SourceType {
        case image(URL)
        case video(URL)
    }
    let name: String
    let type: SourceType
    
    enum Format: String {
        case MOV = ".MOV"
        case jpg = ".jpg"
        case png = ".png"
    }
}
