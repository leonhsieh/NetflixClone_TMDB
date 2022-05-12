//
//  Extensions.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/12.
//

import Foundation

extension String {
    func capitalizeFistLetter() -> String{
        //prefix function可以回傳()內的
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
