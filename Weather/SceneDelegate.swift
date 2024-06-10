//
//  SceneDelegate.swift
//  Weather
//
//  Created by Nicolas Bolzan on 07/06/2024.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let entryPoint = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: entryPoint)
        
        let localCoordinates = ArrayCodable<Forecast>.current?.elements
            .map {
                CLLocationCoordinate2D(
                    latitude: $0.coordinates?.latitude ?? 0,
                    longitude: $0.coordinates?.longitude ?? 0
                )
            } ?? []
        
        let service = NetworkingManager()
        let viewModel = MainWeatherViewModel(service: service,
                                             localCoordinates: localCoordinates)
        let controller = MainWeatherViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: controller)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}

