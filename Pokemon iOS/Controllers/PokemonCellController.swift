//
//  PokemonCellController.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import UIKit

public protocol PokemonCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class PokemonCellController: PokemonImageView {
    
    private let delegate: PokemonCellControllerDelegate
    private var cell: PokemonCell?
    
    public init(delegate: PokemonCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestImage()
        return cell!
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    public func display(_ viewModel: PokemonViewModel<UIImage>) {
        cell?.numberLabel.text = "\(viewModel.id)"
        cell?.nameLabel.text = viewModel.name
        cell?.pokemonImageView.setImageAnimated(viewModel.image)
        cell?.pokemonImageContainer.isShimmering = viewModel.isLoading
        cell?.pokemonImageRetryButton.isHidden = !viewModel.shouldRetry
        cell?.onRetry = delegate.didRequestImage
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
