//
//  DataPersistanceManager.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/31.
//

import UIKit
import CoreData

//這裡負責下載資料＆和CoreData API對話，避免直接在cell做這些事情

class DataPersistanceManager {
    
    enum DataBaseError: Error {
        case failedSaveData
        case failedFetchData
        case failedDeleteData
        case failedUpdateData
    }
    
    static let shared = DataPersistanceManager()
    
    //從CollectionViewCell接收title，增加一個會回傳Result的逃逸函式
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        
        //新增一個contexManager，管理傳入的Title model及資料儲存方式(進行對話）
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        //將NetflixCloneModel中的TitleItem指派給item
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.release_date = model.release_date
        item.vote_average = item.vote_average
        item.vote_count = item.vote_count
        
        do {
            try context.save()//儲存資料完成
            completion(.success(()))//將success傳入completion，因為void是 Type不是物件，因此我們只要使用一個空白括弧就好
        } catch {
            completion(.failure(DataBaseError.failedSaveData))
        }
        
    }
    
    func fetchTitleItemFromDB(compleiton: @escaping (Result<[TitleItem],Error>)-> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        //使用NSFetchRequest從CoreData讀取資料
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            compleiton(.success(results))//成功的話會獲得一個results array
        } catch {
            compleiton(.failure(DataBaseError.failedFetchData))
        }
        
    }
    
    func deleteTitleItemFromDB(model: TitleItem, completion: @escaping (Result<Void,Error>)-> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)//要求 Database Manager: contex 刪除特定物件
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedDeleteData))
        }
    }
}
