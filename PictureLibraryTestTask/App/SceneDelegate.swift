//
//  SceneDelegate.swift
//  PictureLibraryTestTask
//
//  Created by Артем Орлов on 03.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let appBuilder: ImageListModuleBuilder = AppBuilder()
        let rootViewController = appBuilder.buildImageListModule()

        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

}

