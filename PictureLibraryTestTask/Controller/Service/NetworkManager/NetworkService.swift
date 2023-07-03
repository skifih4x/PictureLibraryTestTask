//
//  NetworkService.swift
//  PictureLibraryTestTask
//
//  Created by Артем Орлов on 03.07.2023.
//

import Foundation

protocol ImageService {
    func fetchImages(page: Int, completion: @escaping ([Image]?, Error?) -> Void)
}

class NetworkService: ImageService {
    func fetchImages(page: Int, completion: @escaping ([Image]?, Error?) -> Void) {
        let urlString = "https://api.unsplash.com/photos/?page=\(page)&per_page=10&client_id=UWDQoLJWLHCsebfy2pnVh7uKd_DLyMTXO9B5CIpBp18"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }

            do {
                let images = try JSONDecoder().decode([UnsplashImage].self, from: data)
                let convertedImages = images.map { unsplashImage in
                    return Image(id: unsplashImage.id, url: unsplashImage.urls.regular, height: unsplashImage.height, width: unsplashImage.width)
                }

                completion(convertedImages, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }
}
