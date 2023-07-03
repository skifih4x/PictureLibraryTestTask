//
//  ImageListViewModel.swift
//  PictureLibraryTestTask
//
//  Created by Артем Орлов on 03.07.2023.
//

import UIKit

class ImageListViewModel {
    
    private let imageService: ImageService
    private var currentPage = 1

    var images: [Image] = []

    init(imageService: ImageService) {
        self.imageService = imageService
    }

    func fetchImages(completion: @escaping (Error?) -> Void) {
        imageService.fetchImages(page: currentPage) { [weak self] fetchedImages, error in
            guard let self = self else { return }

            if let fetchedImages = fetchedImages {
                self.images.append(contentsOf: fetchedImages)
                self.currentPage += 1
                completion(nil)
            } else {
                completion(error)
            }
        }
    }


    func numberOfImages() -> Int {
        return images.count
    }

    func image(at index: Int) -> Image {
        return images[index]
    }
}
