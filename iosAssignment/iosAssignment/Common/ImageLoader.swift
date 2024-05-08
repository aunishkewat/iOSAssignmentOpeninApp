//
//  ImageLoader.swift
//  iosAssignment
//
//  Created by Aunish Jayprakash Kewat on 08/05/24.
//

import Foundation
import UIKit

class ImageLoader {
    private let cache = NSCache<NSURL, UIImage>()
    private let session = URLSession.shared

    func loadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }

        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            DispatchQueue.main.async {
                self.cache.setObject(image, forKey: url as NSURL)
                completion(image)
            }
        }

        task.resume()
    }
}
