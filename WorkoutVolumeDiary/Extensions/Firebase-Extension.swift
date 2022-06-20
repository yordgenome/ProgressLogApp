//
//  Firebase-Extension.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/05.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

extension Auth {
    
    static func createUserToFireAuth(model: UserModel, completion: @escaping (Bool) -> Void) {
        guard let email = model.emailString else { return }
        guard let password = model.passwordString else { return }
        
        // FireAuthにユーザーを登録
        Auth.auth().createUser(withEmail: email, password: password) { auth, err in
            if let err = err {
                print("auth情報の保存に失敗", err)
                completion(false)
                return
            }
            else {
                print("auth情報の保存に成功")
                completion(true)
                
            }
            guard let uid = auth?.user.uid else { return }
            //             Authに登録したuidでFirestoreにユーザー情報を登録
            Firestore.setUserDataToFirestore(model: model, uid: uid) { success in
                completion(success)
            }
        }
    }
    
    // FireAuthにログインするメソッド
    static func loginWithFireAuth(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Authにログイン
        Auth.auth().signIn(withEmail: email, password: password) { res, err in
            if let err = err {
                print("ログインに失敗: ", err)
                completion(false)
                return
            }
            
            print("ログインに成功")
            completion(true)
        }
    }
}

extension Firestore {
    
    static let db = firestore()
    
    static func setWorkoutToFirestore(dateString: String, workout: [WorkoutModel], completion: @escaping (Bool) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        for model in workout{
            
            let document = ["workoutName": model.workoutName,
                            "targetPart": model.targetPart.toString(),
                            "doneAt": model.doneAt,
                            "weight": model.weight,
                            "reps": model.reps,
                            "volume": model.volume] as [String : Any]
            
            db.collection("users").document(uid).collection("workout").document().setData(document)
        }
        
        completion(true)
    }
    
    static func fetchWorkoutFromFirestore(uid: String, dateString: String, targetPart: TargetPart, completion: @escaping ([WorkoutModel]) -> Void) {
        
        //        Firestore.firestore().collection("users").document(uid).collection("workout").whereField("tagetPart", isEqualTo: targetPart.toString()).getDocuments { snapshots, err in
        db.collection("users").document(uid).collection("workout").getDocuments{ snapshots, err in
            
            var workoutArray: [WorkoutModel] = []
            
            if let err = err {
                print("データ取得に失敗: ", err)
                return
            }
            else {
                let mapData = snapshots?.documents ?? []
                
                for document in mapData {
                    let workoutName: String = document.data()["workoutName"] as! String
                    let targetPart: TargetPart = TargetPartUtils.toTargetPartg(document.data()["targetPart"] as! String)
                    let doneAt: Timestamp = document.data()["doneAt"] as! Timestamp
                    let weight: Double = document.data()["weight"] as! Double
                    let reps: Double = document.data()["reps"] as! Double
                    let volume: Double = document.data()["volume"] as! Double
                    
                    let data = WorkoutModel(doneAt: doneAt, targetPart: targetPart, workoutName: workoutName, weight: weight, reps: reps, volume: volume)
                    workoutArray.append(data)
                }
                
                completion(workoutArray)
                
            }
        }
    }
    
    //     Firestoreにユーザー情報を保存するメソッド
    static func setUserDataToFirestore(model: UserModel, uid: String, completion: @escaping (Bool) -> Void) {
        guard let name = model.nameString else { return }
        guard let  email = model.emailString else { return }
        
        let document = [
            "name": name,
            "email": email,
            "createdAt": Timestamp(),
            "uid": uid
        ] as [String : Any]
        
        // uidに紐づけてユーザー情報をFirestoreに保存
        db.collection("users").document(uid).setData(document) { err in
            if let err = err {
                print("ユーザー情報のFirestoreへの保存に失敗", err)
                return
            }
            completion(true)
            print("ユーザー情報のFirestoreへの保存が成功")
        }
        
    }

}





//    // Firestoreからユーザー情報を取得するメソッド
//    static func fetchUserFromFirestore(uid: String, completion: @escaping (User?) -> Void) {
//
//        // ユーザー情報変更時自動で呼び出し(.addSnapshotListener)
//        Firestore.firestore().collection("users").document(uid).addSnapshotListener { snapshot, err in
//            if let err = err {
//                print("ユーザー情報の取得に失敗: ", err)
//                completion(nil)
//                return
//            }
//
//            guard let dic = snapshot?.data() else { return }
//            let user = User(dic: dic)
//            completion(user)
//        }
//    }

// Firestoreから自分以外のユーザー情報を取得するメソッド
//    static func fetchUsersFromFirestore(completion: @escaping ([User]) -> Void) {
//
//        // Firestoreから他ユーザーの情報を取り出して辞書型の定数userとして取得
//        Firestore.firestore().collection("users").getDocuments { snapshots, err in
//            if let err = err {
//                print("ユーザーズ情報の取得に失敗: ", err)
//                return
//            }
//
//            let users = snapshots?.documents.map({ (snapshot) -> User in
//                let dic = snapshot.data()
//                let user = User(dic: dic)
//                return user
//            })
//
//            //ユーザーズ情報から自分の情報を除外
//            let filteredUsers = users?.filter({ (user) -> Bool in
//                return user.uid != Auth.auth().currentUser?.uid
//            })
//            completion(filteredUsers ?? [User]())
//        }
//    }


//    // ユーザー情報を更新するメソッド
//    static func updateUserInfo(dic: [String: Any], completion: @escaping () -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        // Firestoreの自分のユーザー情報を更新
//        Firestore.firestore().collection("users").document(uid).updateData(dic) { err in
//            if let err = err {
//                print("ユーザー情報の更新に失敗", err)
//                return
//            }
//
//            completion()
//            print("ユーザー情報の更新に成功")
//        }
//    }
//}
