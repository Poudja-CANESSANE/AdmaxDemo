//
//  LBCGamInterstitialAdUnitProtocol.swift
//  AdmaxDemo
//
//  Created by Poudja.canessane on 18/02/2022.
//  Copyright © 2022 Admax. All rights reserved.
//

import AdmaxPrebidMobile

protocol LBCGamInterstitialAdUnitProtocol: LBCAdUnitProtocol {
    func createDfpOnlyInterstitial()
    func setGamAdUnitId(gamAdUnitId: String)
}

extension GamInterstitialAdUnit: LBCGamInterstitialAdUnitProtocol {}

