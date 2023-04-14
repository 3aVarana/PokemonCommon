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

class PokemonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

