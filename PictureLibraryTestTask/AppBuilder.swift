//
//  AppBuilder.swift
//  PictureLibraryTestTask
//
//  Created by Артем Орлов on 03.07.2023.
//

import UIKit

import UIKit

protocol ImageListModuleBuilder {
    func buildImageListModule() -> UIViewController
}

class AppBuilder: ImageListModuleBuilder {
    func buildImageListModule() -> UIViewController {
        let network = NetworkService()
        let imageVM = ImageListViewModel(imageService: network)
        let vc = ImageListViewController(viewModel: imageVM)
        let navigation = UINavigationController(rootViewController: vc)
        return navigation
    }
}
