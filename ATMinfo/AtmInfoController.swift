//
//  AtmInfoController.swift
//  ATMinfo
//
//  Created by Vlad Kulakovsky  on 12.01.23.
//

import UIKit

class AtmInfoController: UIViewController {
    private(set) var atm: AtmModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func set(atm: AtmModel) {
        self.atm = atm
    }
}
