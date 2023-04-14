//
//  ViewController.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import UIKit
import PokemonCommon
import CoreData

public protocol PokemonViewControllerDelegate {
    func didRequestPokemonRefresh()
}

public final class PokemonViewController: UITableViewController, UITableViewDataSourcePrefetching, PokemonListView, PokemonLoadingView, PokemonErrorView {
    
    @IBOutlet private(set) public var errorView: ErrorView?
    
    private var loadingControllers = [IndexPath: PokemonCellController]()

    public var tableModel = [PokemonCellController]() {
        didSet { tableView.reloadData() }
    }
    
    public var delegate: PokemonViewControllerDelegate?
    
    private var remotePokemonLoader: RemotePokemonLoader?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    private lazy var store: PokemonStore = {
        try! CoreDataPokemonStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("pokemon-store.sqlite"),
            bundle: Bundle(for: CoreDataPokemonStore.self))
    }()
    
    private lazy var localFeedLoader: LocalPokemonLoader = {
        LocalPokemonLoader(store: store)
    }()
    
    public var shouldSetupDelegate = true

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = PokemonPresenter.title
        setupDelegate()
        refresh()
    }
    
    private func setupDelegate() {
        guard shouldSetupDelegate else { return }
        let adapter = PokemonLoaderPresentationAdapter(feedLoader: getRemoteFeedLoaderWithLocalFallback)
        adapter.presenter = PokemonPresenter(pokemonView: self, loadingView: WeakRefVirtualProxy(self), errorView: WeakRefVirtualProxy(self))
        delegate = adapter
    }
    
    func getRemoteFeedLoaderWithLocalFallback() -> PokemonLoader.Publisher {
        let remoteURL = URL(string: "https://stoplight.io/mocks/pokedex/pokeapi/158224127/pokemon")!
        
        let remotePokemonLoader = RemotePokemonLoader(url: remoteURL, client: httpClient)
        self.remotePokemonLoader = remotePokemonLoader
        
        return remotePokemonLoader
            .loadPublisher()
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestPokemonRefresh()
    }

    public func display(_ cellControllers: [PokemonCellController]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }
    
    public func display(_ viewModel: PokemonListViewModel) {
        tableModel = viewModel.pokemonList.map { model in
            let adapter = PokemonImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<PokemonCellController>, UIImage>(model: model)
            let view = PokemonCellController(delegate: adapter)
            
            adapter.presenter = PokemonImagePresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            
            return view
        }
    }
    
    public func display(_ viewModel: PokemonLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    public func display(_ viewModel: PokemonErrorViewModel) {
        errorView?.message = viewModel.message
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> PokemonCellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
    
}

