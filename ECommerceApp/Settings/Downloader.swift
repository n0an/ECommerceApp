//
//  Downloader.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase


let storage = Storage.storage()

func downloadImages(urls: String, withBlock block: @escaping (_ images: [UIImage]?) -> Void) {
    
    let linksArray = separateImageLinks(allLinks: urls)
    
    var imageArray = [UIImage]()
    var downloadCounter = 0
    
    for link in linksArray {
        
        let url = NSURL(string: link)
        
        // !!!IMPORTANT!!!
        // Synchronize several threads
        
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        
        downloadQueue.async {
            
            downloadCounter += 1
            
            let data = NSData(contentsOf: url! as URL)
            
            
            if let data = data {
                
                let image = UIImage(data: data as Data)
                
                imageArray.append(image!)
                
                if downloadCounter == imageArray.count {
                    DispatchQueue.main.async {
                        
                        block(imageArray)
                    }
                }
            } else {
                print("Couldn't download image")
                
                block(imageArray)
            }
            
        }
        
        
    }
    
}


func uploadImages(images: [UIImage], userId: String, referenceNumber: String, withBlock block: @escaping (_ imageLink: String?) -> Void) {
    
     convertImagesToDataArray(images: images) { (datas) in
        var uploadCounter = 0
        var nameSuffix = 0
        var linkString = ""
        
        for pictureData in datas {
            
            let fileName = "PropertyImages/" + userId + "/" + referenceNumber + "/image" + "\(nameSuffix)" + ".jpg"
            
            nameSuffix += 1
            
            let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
            
            var task: StorageUploadTask!
            
            task = storageRef.putData(pictureData, metadata: nil, completion: { (meta, error) in
                
                uploadCounter += 1
                
                if let error = error {
                    print("error uploading picture \(error.localizedDescription)")
                    return
                }
                
                let link = meta!.downloadURL()
                linkString = linkString + link!.absoluteString + ","
                
                if uploadCounter == datas.count {
                    task.removeAllObservers()
                    block(linkString)
                }
                
            })
            
        }
        
    }
    
}


// MARK: - HELPER FUNCTIONS

func separateImageLinks(allLinks: String) -> [String] {
    var linksArray = allLinks.components(separatedBy: ",")
    linksArray.removeLast()
    return linksArray
}


func convertImagesToDataArray(images: [UIImage], withBlock block: @escaping (_ datas: [Data]) -> Void) {
    
    var dataArray = [Data]()
    
    for image in images {
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)!
        
        dataArray.append(imageData)
        
        
    }
    block(dataArray)
    
    
}
















