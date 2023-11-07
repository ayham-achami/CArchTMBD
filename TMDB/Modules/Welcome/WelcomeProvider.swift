//
//  WelcomeProvider.swift
//

import CArch

/// Протокол взаимодействия с WelcomePresenter
protocol WelcomePresentationLogic: RootPresentationLogic {
    
    func didObtain(_ posters: [String])
}

/// Объект содержаний логику получения данных из слоя бизнес логики
/// все типы данных передаются WelcomePresenter как `UIModel`
final class WelcomeProvider: WelcomeProvisionLogic {
    
    private let presenter: WelcomePresentationLogic
    
    /// Инициализация провайдера модуля `Welcome`
    /// - Parameter presenter: `WelcomePresenter`
    nonisolated init(presenter: WelcomePresentationLogic) {
        self.presenter = presenter
    }
    
    func obtainPosters() async throws {
        let posters = [
            "/uS1AIL7I1Ycgs8PTfqUeN6jYNsQ.jpg",
            "/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg",
            "/rktDFPbfHfUbArZ6OOOKsXcv0Bm.jpg",
            "/gPbM0MK8CP8A174rmUwGsADNYKD.jpg",
            "/4m1Au3YkjqsxF8iwQy0fPYSxE0h.jpg",
            "/zsbolOkw8RhTU4DKOrpf4M7KCmi.jpg",
            "/qayga07ICNDswm0cMJ8P3VwklFZ.jpg",
            "/bBON9XO9Ek0DjRwMBnJNCwC96Cd.jpg",
            "/kgrLpJcLBbyhWIkK7fx1fM4iSvf.jpg",
            "/9dTO2RygcDT0cQkawABw4QkDegN.jpg",
            "/eeJjd9JU2Mdj9d7nWRFLWlrcExi.jpg",
            "/jP2ik17jvKiV5sGEknMFbZv7WAe.jpg",
            "/50WLieQSV6WSPoNjhf0GabbOeey.jpg",
            "/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg",
            "/4XLZS2xvdv5rxizzTUVREtRyw95.jpg",
            "/qW4crfED8mpNDadSmMdi7ZDzhXF.jpg",
            "/8riWcADI1ekEiBguVB9vkilhiQm.jpg",
            "/kSf9svfL2WrKeuK8W08xeR5lTn8.jpg",
            "/NNxYkU70HPurnNCSiCjYAmacwm.jpg",
            "/uiFcFIjig0YwyNmhoxkxtAAVIL2.jpg",
            "/mvjqqklMpHwOxc40rn7dMhGT0Fc.jpg",
            "/zjWAjosdXELkaqCnlc1s8FQtIZL.jpg",
            "/kdPMUMJzyYAc4roD52qavX0nLIC.jpg",
            "/3IhGkkalwXguTlceGSl8XUJZOVI.jpg",
            "/gNPqcv1tAifbN7PRNgqpzY8sEJZ.jpg",
            "/5kiLS9nsSJxDdlYUyYGiSUt8Fi8.jpg",
            "/znSKKjTpwnFmlieJtnlLoI6McKK.jpg",
            "/kCyAyqF6TKylJFuddaHtqq20b62.jpg",
            "/ygO9lowFMXWymATCrhoQXd6gCEh.jpg",
            "/Af4bXE63pVsb2FtbW8uYIyPBadD.jpg",
            "/wDWwtvkRRlgTiUr6TyLSMX8FCuZ.jpg",
            "/6P4bZuV9barAeJstqAwkE1F0XmN.jpg",
            "/3LShl6EwqptKIVq6NWOZ0FbZHEe.jpg",
            "/995t1sb4ummXHBfKlXLSM1IAEjc.jpg",
            "/5xeNPGbM8ImVdJACUoGpXT8Pxx3.jpg",
            "/tiZF8b9T9fMcwvsEEkJ5ik1wCnV.jpg",
            "/ueO9MYIOHO7M1PiMUeX74uf8fB9.jpg",
            "/jUjg01KWd11nycbtXhJKghZFD7V.jpg",
            "/2lEyzOq6ILNgBpLLpTRckQhbNNt.jpg",
            "/vIeu8WysZrTSFb2uhPViKjX9EcC.jpg"
          ]
        presenter.didObtain(posters)
    }
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}
