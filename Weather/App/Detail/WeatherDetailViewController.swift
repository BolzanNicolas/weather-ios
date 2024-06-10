//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by Nicolas Bolzan on 07/06/2024.
//

import UIKit

final class WeatherDetailViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: WeatherDetailViewModel
    
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        self.viewModel = .init(service: NetworkingManager(),
                               name: "",
                               coordinates: .init(latitude: 0, longitude: 0))
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.name
        
        viewModel.delegate = self
        configureTableView()
        
        Task {
            try? await viewModel.getWeatherDetail()
        }
    }
    
    private func configureTableView() {
        tableView.register(cellType: ExtendedWeatherTableViewCell.self)
        tableView.dataSource = self
    }
}

extension WeatherDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellType: ExtendedWeatherTableViewCell.self)
        let forecasts = viewModel.weatherDetail[indexPath.row]
        cell.setup(with: forecasts)
        return cell
    }
}
extension WeatherDetailViewController: WeatherDetailDelegate {
    
    func showError(_ error: Error) {
        // TODO: present popup with error message
    }
    
    func didLoadDetail() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
