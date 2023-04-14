//
//  PokemonViewControllerDelegate.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import Combine
import PokemonCommon

final class PokemonLoaderPresentationAdapter: PokemonViewControllerDelegate {
    
    private let feedLoader: () -> PokemonLoader.Publisher
    private var cancellable: Cancellable?
    var presenter: PokemonPresenter?

    init(feedLoader: @escaping () -> PokemonLoader.Publisher) {
        self.feedLoader = feedLoader
    }

    func didRequestPokemonRefresh() {
        presenter?.didStartLoadingPokemonList()

        cancellable = feedLoader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break

                    case let .failure(error):
                        self?.presenter?.didFinishLoadingPokemonList(with: error)
                    }
                }, receiveValue: { [weak self] pokemonList in
                    self?.presenter?.didFinishLoadingPokemonList(with: pokemonList)
                })
    }
}
