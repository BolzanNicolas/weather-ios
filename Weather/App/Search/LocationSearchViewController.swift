//
//  LocationSearchViewController.swift
//  Weather
//
//  Created by Nicolas Bolzan on 09/06/2024.
//

import UIKit
import CoreLocation

final class LocationSearchViewController: UIViewController {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = LocationSearchViewModel()
    
    weak var delegate: LocationSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        searchBar.delegate = self
    }
    
    private func configureTableView() {
        tableView.register(cellType: SearchResultTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension LocationSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.placemarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellType: SearchResultTableViewCell.self)
        let placemark = viewModel.placemarks[indexPath.row]
        cell.setup(with: placemark)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchResultTableViewCell.HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let location = viewModel.placemarks[indexPath.row].location?.coordinate {
            delegate?.didSelectLocation(location)
            dismiss(animated: true)
        }
    }
}

extension LocationSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.placemarks = []
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        
        guard let text = searchBar.text else {
            return
        }
        
        activityIndicatorView.startAnimating()
        
        viewModel.search(keyword: text) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                // TODO: Show error
                viewModel.placemarks = []
            default: break
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
}

protocol LocationSearchDelegate: AnyObject {
    func didSelectLocation(_ coordinates: CLLocationCoordinate2D)
}
