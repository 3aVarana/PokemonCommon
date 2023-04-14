//
//  Pokemon_iOSTests.swift
//  Pokemon iOSTests
//
//  Created by Victor Arana on 4/13/23.
//

import XCTest
import PokemonCommon
import Pokemon_iOS

final class Pokemon_iOSTests: XCTestCase {

    func test_emptyPokemonList_lightMode() {
        let sut = makeSUT()

        sut.display(emptyPokemonList())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "pokemon_list_light")
        
    }
    
    func test_emptyPokemonList_darkMode() {
        let sut = makeSUT(style: .dark)

        sut.display(emptyPokemonList())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "pokemon_list_dark")
    }
    
    func test_pokemonListWithErrorMessage_lightMode() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "pokemon_list_error_light")
    }
    
    func test_pokemonListWithErrorMessage_darkMode() {
        let sut = makeSUT(style: .dark)

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "pokemon_list_error_dark")
    }
    
    func test_pokemonListWithContent_lightMode() {
        let sut = makeSUT()

        sut.display(pokemonListWithContent())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "pokemon_list_with_content_light")
    }
    
    func test_pokemonListWithContent_darkMode() {
        let sut = makeSUT(style: .dark)

        sut.display(pokemonListWithContent())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "pokemon_list_with_content_dark")
    }
    
    // MARK: - Helpers
    private func makeSUT(style: UIUserInterfaceStyle = .light) -> PokemonViewController {
        let bundle = Bundle(for: PokemonViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        navController.overrideUserInterfaceStyle = style
        let controller = navController.viewControllers[0] as! PokemonViewController
        controller.shouldSetupDelegate = false
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyPokemonList() -> [PokemonCellController] {
        return []
    }
    
    private func pokemonListWithContent() -> [PokemonStub] {
        return [
            PokemonStub(id: 1, name: "Bulbasaur", image: UIImage.make(withColor: .red)),
            PokemonStub(id: 2, name: "Ivysaur", image: UIImage.make(withColor: .systemPink))
        ]
    }

}

private extension PokemonViewController {
    func display(_ stubs: [PokemonStub]) {
        let cells: [PokemonCellController] = stubs.map { stub in
            let cellController = PokemonCellController(delegate: stub)
            stub.controller = cellController
            return cellController
        }

        display(cells)
    }
}

private class PokemonStub: PokemonCellControllerDelegate {
    let viewModel: PokemonViewModel<UIImage>
    weak var controller: PokemonCellController?

    init(id: Int, name: String, image: UIImage?) {
        viewModel = PokemonViewModel(id: id,
                                     name: name,
                                     image: image,
                                     isLoading: false,
                                     shouldRetry: image == nil,
                                     types: [PokemonType(slot: 1, code: 2, name: "grass")])
    }

    func didRequestImage() {
        controller?.display(viewModel)
    }

    func didCancelImageRequest() {}
}
