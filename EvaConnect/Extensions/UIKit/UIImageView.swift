//
//  UIImageView.swift
//  EvaConnect
//
//  Created by usama on 11/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    typealias ImageHandler = (UIImage?, Error?) -> Void
    
    func getImage(urlString: String?, completion: @escaping ImageHandler ) {
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        let cache = ImageCache.default
        let resource = ImageResource(downloadURL: url)
        
        if cache.isCached(forKey: urlString) {
            cache.retrieveImage(forKey: "cacheKey") { result in
                switch result {
                case .success(let value):
                    switch value {
                    case .none:
                        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                            switch result {
                            case .success(let value):
                                //                                print("Image: \(value.image). Got from: \(value.cacheType)")
                                completion(value.image, nil)
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        }
                    case .disk:
                        DispatchQueue.main.async { completion(value.image, nil) }
                    case .memory:
                        DispatchQueue.main.async { completion(value.image, nil) }
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        } else {
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    //                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    completion(value.image, nil)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func loadLocalImage(by url: URL) {
        do {
            image = UIImage(data: try Data(contentsOf: url))
        } catch let error {
            print("error => \(error.localizedDescription)")
        }
    }
}
