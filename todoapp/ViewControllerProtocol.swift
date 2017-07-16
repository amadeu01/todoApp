//
//  ViewControllerProtocol.swift
//  todoapp
//
//  Created by Amadeu Cavalcante Filho on 7/15/17.
//  Copyright © 2017 Amadeu Cavalcante Filho. All rights reserved.
//

import UIKit

protocol ViewControllerProtocol {
    func didUpdateList(reload: Bool)    
    func uiWrite(block: () -> Void)
    func uiWriteNoUpdateList(block: () -> Void)
    func finishUIWrite()
}
