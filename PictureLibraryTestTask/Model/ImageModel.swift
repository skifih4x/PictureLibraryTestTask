//
//  ImageModel.swift
//  PictureLibraryTestTask
//
//  Created by Артем Орлов on 03.07.2023.
//
import Foundation

//Добавил init для проверки валидности, проверки будут ли использоваться.

struct Image {
    let id: String
    let url: URL
    let height: Int
    let width: Int

    init(id: String, url: URL, height: Int, width: Int) {
        self.id = id
        self.url = url
        self.height = height
        self.width = width
    }
}

struct UnsplashImage: Codable {
    let id: String
    let urls: URLs
    let height: Int
    let width: Int
}

struct URLs: Codable {
    let regular: URL

    init(regular: URL) {
        self.regular = regular
    }
}
