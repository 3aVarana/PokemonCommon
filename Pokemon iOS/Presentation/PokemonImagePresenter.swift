//
//  PokemonImagePresenter.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import Foundation
import PokemonCommon

public protocol PokemonImageView {
    associatedtype Image
    
    func display(_ model: PokemonViewModel<Image>)
}

public final class PokemonImagePresenter<View: PokemonImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: Pokemon) {
        view.display(PokemonViewModel(
            id: model.id,
            name: model.name,
            image: nil,
            isLoading: true,
            shouldRetry: false,
            types: model.types))
    }
    
    public func didFinishLoadingImageData(with data: Data, for model: Pokemon) {
        let image = imageTransformer(data)
        view.display(PokemonViewModel(
            id: model.id,
            name: model.name,
            image: image,
            isLoading: false,
            shouldRetry: image == nil,
            types: model.types))
    }
    
    public func didFinishLoadingImageData(with error: Error, for model: Pokemon) {
        view.display(PokemonViewModel(
            id: model.id,
            name: model.name,
            image: nil,
            isLoading: false,
            shouldRetry: true,
            types: model.types))
    }
}
