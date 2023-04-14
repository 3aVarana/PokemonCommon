//
//  PokemonPresenter.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import Foundation
import PokemonCommon

public protocol PokemonView {
    func display(_ viewModel: PokemonViewModel)
}

public protocol PokemonLoadingView {
    func display(_ viewModel: PokemonLoadingViewModel)
}

public protocol PokemonErrorView {
    func display(_ viewModel: PokemonErrorViewModel)
}

public final class PokemonPresenter {
    private let pokemonView: PokemonView
    private let loadingView: PokemonLoadingView
    private let errorView: PokemonErrorView
    
    public static var title = "Pokedéx"
    private var feedLoadError = "No se pudo conectar al servidor"
    
    public init(pokemonView: PokemonView, loadingView: PokemonLoadingView, errorView: PokemonErrorView) {
        self.pokemonView = pokemonView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public func didStartLoadingPokemonList() {
        errorView.display(.noError)
        loadingView.display(PokemonLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingPokemonList(with pokemonList: [Pokemon]) {
        pokemonView.display(PokemonViewModel(pokemonList: pokemonList))
        loadingView.display(PokemonLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingPokemonList(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(PokemonLoadingViewModel(isLoading: false))
    }
}
