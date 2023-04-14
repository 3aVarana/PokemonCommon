//
//  ViewController.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import UIKit

public protocol PokemonViewControllerDelegate {
    func didRequestPokemonRefresh()
}

public final class PokemonViewController: UITableViewController, UITableViewDataSourcePrefetching, PokemonLoadingView, PokemonErrorView {
    
    @IBOutlet private(set) public var errorView: ErrorView?
    
    public var delegate: PokemonViewControllerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestPokemonRefresh()
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    public func display(_ viewModel: PokemonLoadingViewModel) {
        
    }
    
    public func display(_ viewModel: PokemonErrorViewModel) {
        
    }
    
}

