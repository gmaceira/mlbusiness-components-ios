//
//  UIImageView+RemoteImage.swift
//  MLBusinessComponents
//
//  Created by Juan sebastian Sanzone on 9/24/19.
//

import Foundation

// codebeat:disable
internal extension UIImageView {
    func setRemoteImage(imageUrl: String, placeHolderRadius: CGFloat = 0, customCache: URLCache? = nil, success:((UIImage)->Void)? = nil) {
        guard let url = URL(string: imageUrl) else { return }
        let cache = customCache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
            success?(image)
            #if DEBUG
            print("Retrieve image from Cache")
            #endif
        } else {
            self.layer.cornerRadius = placeHolderRadius
            self.backgroundColor = UI.Colors.placeHolderColor
            self.layer.masksToBounds = true
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    #if DEBUG
                    print("Retrieve image from Network")
                    #endif
                    UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
                        DispatchQueue.main.async {
                            self?.backgroundColor = .clear
                            self?.layer.cornerRadius = 0
                            self?.image = image
                        }}, completion: { _ in
                            success?(image)
                    }
                    )}
            }).resume()
        }
    }
}
