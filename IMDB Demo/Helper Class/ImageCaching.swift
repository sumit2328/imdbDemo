//
//  ImageCaching.swift
//  IMDB Demo
//
//  Created by Sumit on 01/07/24.
//

import UIKit

// Singleton class to manage image caching and loading
public class ImageLoader {
    
    public static let shared = ImageLoader()
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    public func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString as NSString
        
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        // Download the image from the URL
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data), error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Cache the downloaded image
            self.imageCache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    public func clearCache() {
        imageCache.removeAllObjects()
    }
}

// Extension to UIImageView for convenience
public extension UIImageView {
    func setImage(from url: URL, placeholder: UIImage? = nil) {
        // Set placeholder image if provided
        self.image = placeholder
        
        ImageLoader.shared.loadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.image = image
            }
        }
    }
}
