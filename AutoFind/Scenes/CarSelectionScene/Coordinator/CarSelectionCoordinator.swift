//
//  CarSelectionCoordinator.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import UIKit

class CarSelectionCoordinator: Coordinator {
    
    var rootViewController: UIViewController?
    
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        let carBrandSelectionVC = CategoriesViewController.instantiate(coordinator: self)
        carBrandSelectionVC.viewModel = BrandViewModel(service: CarSelectionService.shared)
        carBrandSelectionVC.title = LocalizedStrings.manifacture.value
        carBrandSelectionVC.didSelectItem = { [weak self] item in
            guard let self = self else { return }
            self.toTheModels(brand: item)
        }
        navigationController.pushViewController(carBrandSelectionVC, animated: animated)
    }
    
    func toTheModels(brand: CategoriesViewType) {
        let carModelSelectionVC = CategoriesViewController.instantiate(coordinator: self)
        carModelSelectionVC.viewModel = CarModelViewModel(service: CarSelectionService.shared, brand: brand)
        carModelSelectionVC.title = LocalizedStrings.models.value
        carModelSelectionVC.didSelectItem = { [weak self] item in
            guard let self = self else { return }
            let message = LocalizedStrings.localize(.choosenCar, brand.title, item.title)
            self.showMessage(title: LocalizedStrings.welldone.value, message: message)
        }
        navigationController.pushViewController(carModelSelectionVC, animated: true)
    }
    
    func showMessage(title: String = LocalizedStrings.error.value, message: String, buttonTitle: String = LocalizedStrings.ok.value) {
        let ac = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.navigationController.present(ac, animated: true, completion: nil)
    }
    
    deinit {
        print("Removed \(self) from memory")
    }
}
