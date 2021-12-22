//
//  CategoriesViewController.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/16/21.
//

import UIKit

// Its better to make seperate views for each usage
// but in this usecase for the sake of time I use redeclerative and reusable generic model
protocol CategoriesViewType {
    var title: String { get }
    var CarID: String { get }
}

class CategoriesViewController: UIViewController, Storyboarded {
    
    weak var coordinator: CarSelectionCoordinator?
    
    var viewModel: PaginatableCategoriesViewModelType?
    
    var dataSource: AutoFindTableViewDataSource<CategoryCell>!
    
    var didSelectItem: DataCompletion<CategoriesViewType> = { _ in }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupBinding()
        callService()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupView() {
        dataSource = AutoFindTableViewDataSource(cellHeight: 0, items: [], tableView: tableView, delegate: self, animationType: .type1(0.3))
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.contentInset.top = 10
        
        self.view.backgroundColor = .BackGround.lightGreenGreen
        
    }
    
    private func callService() {
        viewModel?.callService()
    }
    
    private func setupBinding() {
        
        viewModel?.loading = { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.view.animateActivityIndicator() : self.view.removeActivityIndicator()
        }
        
        viewModel?.errorHandler = { [weak self] error in
            guard let self = self else { return }
            self.coordinator?.showMessage(message: error)
        }
        
        viewModel?.successResponseHandler = { [weak self] list in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dataSource.appendItemsToTableView(list)
            }
        }
    }
}

extension CategoriesViewController: AutoFindTableViewDelegate {
    
    func tableView(willDisplay cellIndexPath: IndexPath, cell: UITableViewCell) {
        // For pagination
        viewModel?.getNextPageIfValid(index: cellIndexPath.row, totalItems: dataSource.items.count - 1)
        
        // for Customizing colors
        guard let cell = cell as? CategoryCell else { return }
        cell.isOdd(cellIndexPath.row % 2 == 0)
    }
    
    func tableView<T>(didSelectModelAt model: T) {
        guard let model = model as? CategoriesViewType else { return }
        didSelectItem(model)
    }
}
