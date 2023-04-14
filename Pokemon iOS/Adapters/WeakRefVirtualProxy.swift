//
//  WeakRefVirtualProxy.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/14/23.
//

import Foundation
import UIKit

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: PokemonErrorView where T: PokemonErrorView {
    func display(_ viewModel: PokemonErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: PokemonLoadingView where T: PokemonLoadingView {
    func display(_ viewModel: PokemonLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: PokemonImageView where T: PokemonImageView, T.Image == UIImage {
    func display(_ model: PokemonViewModel<UIImage>) {
        object?.display(model)
    }
}
