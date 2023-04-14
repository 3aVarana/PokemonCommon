//
//  PokemonCell.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import UIKit

public final class PokemonCell: UITableViewCell {
    @IBOutlet private(set) public var numberLabel: UILabel!
    @IBOutlet private(set) public var nameLabel: UILabel!
    @IBOutlet private(set) public var pokemonImageContainer: UIView!
    @IBOutlet private(set) public var pokemonImageView: UIImageView!
    @IBOutlet private(set) public var pokemonImageRetryButton: UIButton!

    var onRetry: (() -> Void)?

    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
}
