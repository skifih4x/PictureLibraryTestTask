//
//  SceneDelegate.swift
//  PictureLibraryTestTask
//
//  Created by Артем Орлов on 03.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let network = NetworkService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let imageVM = ImageListViewModel(imageService: network)
        let vc = ImageListViewController(viewModel: imageVM)
        let navigation = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}

