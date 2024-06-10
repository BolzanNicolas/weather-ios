//
//  DequeuableRegistrable.swift
//  Weather
//
//  Created by Nicolas Bolzan on 08/06/2024.
//

import UIKit

protocol Identificable { static var identifier: String { get }}
protocol NibInstanciable { static func nib() -> UINib }

extension UICollectionViewCell: Identificable, NibInstanciable {}
extension UITableViewCell: Identificable, NibInstanciable {}

extension Identificable {
    static var identifier: String { return String.init(describing: Self.self) }
}

extension NibInstanciable where Self: Identificable {
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension UICollectionView {
    func register<T:UICollectionViewCell>(cellType: T.Type)  {
        register(cellType.nib(), forCellWithReuseIdentifier: cellType.identifier)
    }
    
    func dequeue<T:UICollectionViewCell>(cellType :T.Type, at indexPath:IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as! T
    }
}

extension UITableView {
    func register<T:UITableViewCell>(cellType: T.Type)  {
        register(cellType.nib(), forCellReuseIdentifier: cellType.identifier)
    }
    
    func dequeue<T:UITableViewCell>(cellType: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: cellType.identifier) as! T
    }
}
