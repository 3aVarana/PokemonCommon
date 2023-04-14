//
//  FeedImageDataLoaderPresentationLoader.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/14/23.
//


import Combine
import Foundation
import PokemonCommon

final class PokemonImageDataLoaderPresentationAdapter<View: PokemonImageView, Image>: PokemonCellControllerDelegate where View.Image == Image {
    private let model: Pokemon
    private var cancellable: Cancellable?
    
    var presenter: PokemonImagePresenter<View, Image>?
    
    init(model: Pokemon) {
        self.model = model
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: model.imageUrl){
                DispatchQueue.main.async {
                    self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                }
            } else {
                DispatchQueue.main.async {
                    self?.presenter?.didFinishLoadingImageData(with: NSError(domain: "error", code: 0), for: model)
                }
            }
        }
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
    }
}
