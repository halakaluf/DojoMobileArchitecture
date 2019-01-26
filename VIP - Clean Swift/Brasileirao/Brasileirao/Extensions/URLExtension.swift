//
//  URLExtension.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 08/01/2019.
//  Copyright © 2019 Fabio Martinez. All rights reserved.
//

import Foundation
import UIKit

extension URL {

    init (clubName: String) {
        switch clubName {
            case "CRU":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/cruzeiro_60x60.png")!
            case "GRE":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/gremio_60x60.png")!
            case "VIT":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/vitoria_60x60.png")!
            case "FLA":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/flamengo_60x60.png")!
            case "SAN":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/santos_60x60.png")!
            case "CEA":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/ceara_60x60.png")!
            case "AME":
                self.init(string: "https://s.glbimg.com/es/sde/f/equipes/2014/04/14/america_mg_60x60.png")!
            case "SPO":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/09/15/sport_60x60.png")!
            case "VAS":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/vasco_60x60.png")!
            case "CAM":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/atletico_mg_60x60.png")!
            case "COR":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/corinthians_60x60.png")!
            case "FLU":
                self.init(string: "https://s.glbimg.com/es/sde/f/equipes/2014/04/14/fluminense_60x60.png")!
            case "INT":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/internacional_60x60.png")!
            case "BAH":
                self.init(string: "https://s.glbimg.com/es/sde/f/equipes/2014/04/14/bahia_60x60.png")!
            case "CAP":
                self.init(string: "https://s.glbimg.com/es/sde/f/equipes/2014/04/14/atletico_pr_60x60.png")!
            case "CHA":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2015/05/06/chapecoense_60x60.png")!
            case "BOT":
                self.init(string: "https://s.glbimg.com/es/sde/f/equipes/2014/04/14/botafogo_60x60.png")!
            case "PAL":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/palmeiras_60x60.png")!
            case "SAO":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/14/sao_paulo_60x60.png")!
            case "PAR":
                self.init(string: "http://s.glbimg.com/es/sde/f/equipes/2014/04/13/parana_60x60.png")!
            default:
                self.init(string: "")!
        }

    }
   
}

