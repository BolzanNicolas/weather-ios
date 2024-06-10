//
//  MainWeatherViewController.swift
//  Weather
//
//  Created by Nicolas Bolzan on 07/06/2024.
//

import UIKit
import CoreLocation

final class MainWeatherViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: MainWeatherViewModel
    private let locationManager = CLLocationManager()
    
    private lazy var dataSource = UITableViewDiffableDataSource<Int, Forecast>(tableView: tableView) { [weak self] (tableView, indexPath, model) -> UITableViewCell? in
        let cell = tableView.dequeue(cellType: MainWeatherTableViewCell.self)
        cell.setup(with: model)
        return cell
    }
    
    init(viewModel: MainWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        self.viewModel = .init(service: NetworkingManager(), localCoordinates: [])
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
        
        viewModel.delegate = self
        
        configureTableView()
        configureLocation()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        guard viewModel.canAddLocation else {
            DispatchQueue.main.async { [weak self] in
                self?.navigationItem.rightBarButtonItem = nil
            }
            return
        }
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(addLocation))
        addButton.tintColor = .label
        DispatchQueue.main.async { [weak self] in
            self?.navigationItem.rightBarButtonItem = addButton
        }
    }
    
    private func configureTableView() {
        tableView.register(cellType: MainWeatherTableViewCell.self)
        tableView.delegate = self
        dataSource.defaultRowAnimation = .left
    }
    
    private func configureLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    @objc private func addLocation() {
        let controller = LocationSearchViewController()
        controller.delegate = self
        present(controller, animated: true)
    }
}

extension MainWeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let forecast = viewModel.forecasts[indexPath.row]
        
        if let coordinates = forecast.coordinates, let name = forecast.name {
            let viewModel = WeatherDetailViewModel(
                service: viewModel.service,
                name: name,
                coordinates: coordinates
            )
            let controller = WeatherDetailViewController(viewModel: viewModel)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action in
            let delete = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                identifier: nil) { [weak self] _ in
                    self?.viewModel.removeLocation(at: indexPath.row)
            }
            return UIMenu(
                title: "Options",
                image: nil,
                identifier: nil,
                children: [delete]
            )
        }
    }
}

extension MainWeatherViewController: MainWeatherDelegate {
    
    func showError(_ error: Error) {
        // TODO: present popup with error message
    }
    
    func didLoadForecast() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Int, Forecast>()
            snapshot.appendSections([1])
            snapshot.appendItems(Array(viewModel.forecasts), toSection: 1)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
        configureNavigationBar()
    }
}

extension MainWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate, viewModel.currentLocation == nil {
            locationManager.stopUpdatingLocation()
            viewModel.currentLocation = coordinate
            viewModel.getCurrentWeather(for: coordinate)
        }
    }
}

extension MainWeatherViewController: LocationSearchDelegate {
    func didSelectLocation(_ coordinates: CLLocationCoordinate2D) {
        viewModel.getCurrentWeather(for: coordinates)
    }
}
