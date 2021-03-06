//
//  SASAdmaxBidderAdapter.swift
//  AdmaxDemo
//
//  Created by Gwen on 15/06/2019.
//  Copyright © 2019 Admax. All rights reserved.
//

import SASDisplayKit

final class SASAdmaxBidderAdapter: NSObject, SASBidderAdapterProtocol {
    var competitionType: SASBidderAdapterCompetitionType = SASBidderAdapterCompetitionType.price
    var keyword: String?
    var creativeRenderingType: SASBidderAdapterCreativeRenderingType = SASBidderAdapterCreativeRenderingType.typePrimarySDK
    var adapterName: String = "SASAdmaxBidderAdapter"
    var winningSSPName: String = ""
    var winningCreativeID: String? = ""
    var hbCacheID: String = ""
    var price: Float = 0
    var currency: String? = "USD"
    var dealID: String? = ""

    private var targetingMap: String = ""
    private var admaxAdDisplayed: Bool = false

    private let admaxAdUnit: LBCAdUnitProtocol
    private let admaxPrebidMobileService: LBCAdmaxPrebidMobileServiceProtocol

    init(adUnit: LBCAdUnitProtocol,
         admaxPrebidMobileService: LBCAdmaxPrebidMobileServiceProtocol = LBCServices.shared.admaxPrebidMobileService) {
        self.admaxAdUnit = adUnit
        self.admaxPrebidMobileService = admaxPrebidMobileService
    }

    func primarySDKDisplayedBidderAd() {
        print("primarySDKDisplayedBidderAd called")
    }

    func primarySDKClickedBidderAd() {
        print("primarySDKClickedBidderAd called")
    }

    func primarySDKLostBidCompetition() {
        print("primarySDKLostBidCompetition called")
        self.admaxAdUnit.isSmartAdServerAd = false
        self.admaxAdDisplayed = true
        if (!self.admaxAdUnit.isSmartAdServerSdkRendering()) {
            self.admaxAdUnit.loadAd()
        }
    }

    func bidderWinningAdMarkup() -> String {
        let appId: String = Bundle.main.bundleIdentifier!
        let adm: String = "<script src = \"https://cdn.admaxmedia.io/creative.js\"></script>\n" +
            "<script>\n" +
            "  var ucTagData = {};\n" +
            "  ucTagData.adServerDomain = \"\";\n" +
            "  ucTagData.pubUrl = \"" + appId + "\";\n" +
            "  ucTagData.targetingMap = " + self.targetingMap + ";\n" +
            "\n" +
            "  try {\n" +
            "    ucTag.renderAd(document, ucTagData);\n" +
            "  } catch (e) {\n" +
            "    console.log(e);\n" +
            "  }\n" +
        "</script>"
        return adm
    }

    func primarySDKRequestedThirdPartyRendering() {}
    func loadBidderBannerAd(in view: UIView, delegate: SASBannerBidderAdapterDelegate?) {}
    func loadBidderInterstitial(with delegate: SASInterstitialBidderAdapterDelegate?) {}
    func showBidderInterstitial(from viewController: UIViewController, delegate: SASInterstitialBidderAdapterDelegate?) {}

    func isInterstitialAdReady() -> Bool {
        return false
    }
}

extension SASAdmaxBidderAdapter: LBCUpdatableProtocol {
    public func update(keywords: [String: String]) {
        let keyValuePrefix: String = self.admaxPrebidMobileService.getKeyvaluePrefix(admaxConfig: self.admaxPrebidMobileService.admaxConfig)
        self.winningSSPName = keywords["hb_bidder"]!
        self.winningCreativeID = keywords["hb_cache_id"] ?? ""
        self.hbCacheID = keywords["hb_cache_id"] ?? ""
        self.price = Float(keywords[keyValuePrefix]!)!
        self.targetingMap = self.stringify(keywords: keywords)
    }

    private func stringify(keywords: [String: String]) -> String {
        let n: Int = keywords.count - 1
        var i: Int = 0
        var keywordsString = "{"
        for (key, value) in keywords {
            keywordsString.append("'")
            keywordsString.append(key)
            keywordsString.append("':['")
            keywordsString.append(value)
            keywordsString.append("']")
            if (i < n) {
                keywordsString.append(",")
            }
            i += 1
        }
        keywordsString.append("}")
        return keywordsString
    }
}
