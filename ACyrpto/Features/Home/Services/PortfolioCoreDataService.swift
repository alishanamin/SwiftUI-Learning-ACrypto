//
//  PortfolioCoreDataService.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 26/09/2025.
//

import Foundation
import CoreData


class PortfolioCoreDataService{
    
    private let container: NSPersistentContainer
    private let entityName = "PortfolioEntity"
    private let conatinerName = "PortfolioContainer"
    
    @Published var portfolio: [PortfolioEntity] = []
    
    
    init(){
        container = NSPersistentContainer(name: conatinerName)
        container.loadPersistentStores { (_,error) in
            if let error = error {
                print("Error in Loading Conatiner! \(error)")
            }
            self.fetchPortfolio()
        }
    }
    
    
    // MARK: Public Function
    
    func updatePortFolio(coin: CoinModel, amount: Double){
        
        if let entity = portfolio.first(where: {$0.coinID == coin.id})
        {
            if amount > 0 {
                update(entity: entity, amount: amount)
            }else{
                delete(entity: entity)
            }
        }else{
            add(coin: coin, amount: amount)
        }
        
    }
    
    // MARK: Private Functions
    
    // For Fetching the portfolio
    
    private func fetchPortfolio(){
        
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            portfolio =  try container.viewContext.fetch(request)
        } catch let error {
            print("Error in Loading Portflio! \(error)")
        }
        
    }
    
    // for adding in portfolio
    
    private func add(coin: CoinModel , amount: Double){
        
        let entity = PortfolioEntity(context: container.viewContext)
    
        entity.amount = amount
        entity.coinID = coin.id
        applyChanges()
    }
    
    // for updating the portfolio
    
    private func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    // for remove/delete from portfolio
    
    private func delete(entity: PortfolioEntity){
        
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error in Save Portflio! \(error)")
        }
    }
    
    private func applyChanges(){
        save()
        fetchPortfolio()
    }

}
