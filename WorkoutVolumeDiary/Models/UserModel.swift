//
//  UserModel.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/23.
//

// MARK: - AuthError
public enum AuthError: Error {
    case networkError
    case weakPassword
    case wrongPassword
    case userNotFound
    case invalidEmail
    case emailAlreadyInUse
    case unknown
    
    var title: String {
        switch self {
        case .networkError:
            return "通信エラーです。"
        case .weakPassword:
            return "パスワードが脆弱です。"
        case .wrongPassword:
            return "メールアドレス、もしくはパスワードが違います。"
        case .userNotFound:
            return "アカウントがありません。"
        case .invalidEmail:
            return "正しくないメールアドレスの形式です。"
        case .emailAlreadyInUse:
            return "既に登録されているメールアドレスです。"
        case .unknown:
            return "エラーが起きました。"
        }
    }
}

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Combine

class UserModel {
        
// MARK: - FirebaseAuth
    static func LoginAndGetError(email: String, password: String) async -> String {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let uid = result.user.uid
            print("ログインに成功")
            return "ログインに成功しました"
        } catch {
            let errorCode = AuthErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .networkError:
                return AuthError.networkError.title
            case .weakPassword:
                return AuthError.weakPassword.title
            case .wrongPassword:
                return AuthError.wrongPassword.title
            case .userNotFound:
                return AuthError.userNotFound.title
            default:
                return AuthError.unknown.title
            }
        }
    }
    
    static func signUpAndGetError(name: String, email: String, password: String) async -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            
            let user = User(id: uid, name: name, email: email, createdAt: Timestamp())
            
            await self.setUserToFirestore(user: user)
            print("アカウント登録に成功")
            return "アカウント登録が完了しました"
        } catch {
            let errorCode = AuthErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .networkError:
                return AuthError.networkError.title
            case .weakPassword:
                return AuthError.weakPassword.title
            case .emailAlreadyInUse:
                return AuthError.emailAlreadyInUse.title
            default:
                return AuthError.unknown.title
            }
        }
    }
    
    static func signOut() async -> String {
        do {
            try Auth.auth().signOut()
            return "サインアウトしました"
        } catch {
            let errorCode = AuthErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .networkError:
                return AuthError.networkError.title
            default:
                return AuthError.unknown.title
            }
        }
    }
    
    static func passwordReset(email: String, password: String) async -> String {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            return "パスワードを再設定するメールを送信しました。"
        } catch {
            let errorCode = AuthErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .networkError:
                return AuthError.networkError.title
            case .userNotFound:
                return AuthError.userNotFound.title
            case .invalidEmail:
                return AuthError.invalidEmail.title
            default:
                return AuthError.unknown.title
            }
        }
    }
    
    //MARK: - Firestore
    static func setUserToFirestore(user: User) async {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await db.collection("users").document(uid).setData([
                "id": user.id,
                "name": user.name,
                "email": user.email,
                "createdAt": user.createdAt
            ])
            print("ユーザー情報の登録に成功")
            
        } catch {
            print("ユーザー情報の登録に失敗", error)
            
        }
    }
    
    static func upDateUserToFirestore(user: User) async {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await db.collection("users").document(uid).updateData([
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "createdAt": user.createdAt
        ])
        print("ユーザー情報の更新に成功")
        } catch {
            print("ユーザー情報の更新に失敗", error)
        }
    }
    
    static func getUserFromFirestore() async throws -> User {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return User(id: "", name: "", email: "", createdAt: Timestamp()) }
        
        let document = try await db.collection("users").document(uid).getDocument(source: .default)
        
        let name = document.data()!["name"] as! String
        let email = document.data()!["email"] as! String
        let createdAt = document.data()!["createdAt"] as! Timestamp
        
        return User(id: uid, name: name, email: email, createdAt: createdAt)
        
    }
    
    static func setWorkoutToFirestore(workout: [WorkoutModel], dateString: String) async throws {
        let db = Firestore.firestore()
        var setData: [String: Any] = [:]
        let dicArray = workout.map{ $0.toDictionary() }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if dicArray.count == 0 {
            return
        } else {
            for i in 0..<dicArray.count {
                setData.updateValue(dicArray[i], forKey: String(i))
            }
        }
        try await db.collection("users").document(uid).collection("workout").document(dateString).setData(setData, merge: true)
    }
    
//    static func setWorkoutToFirestore(workout: [WorkoutModel], dateString: String) async throws {
//        let db = Firestore.firestore()
//        let dicArray = workout.map{ $0.toDictionary() }
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        if dicArray.count == 0 {
//            return
//        } else {
//            for i in 0..<dicArray.count {
//                try await db.collection("users").document(uid).collection("workout").document(dateString).setData([String(i) : dicArray[i]], merge: true)
//            }
//        }
//    }

//    static func upDateWorkoutToFirestore(workout: [WorkoutModel], dateString: String) async throws {
//        let db = Firestore.firestore()
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        for model in workout{
//            let document = ["workoutName": model.workoutName,
//                            "targetPart": model.targetPart.toString(),
//                            "doneAt": model.doneAt,
//                            "weight": model.weight,
//                            "reps": model.reps,
//                            "volume": model.volume] as [String : Any]
//            try await db.collection("users").document(uid).collection("workout").document(dateString).updateData(document)
//        }
//    }
    
//    static func getWorkoutFromFirestore(uid: String) async throws -> [WorkoutModel] {
//        let db = Firestore.firestore()
//        var workoutArray: [WorkoutModel] = []
//        guard let uid = Auth.auth().currentUser?.uid else { return workoutArray }
//
//        let snapshots = try await db.collection("users").document(uid).collection("workout").getDocuments(source: .default)
//        let mapData = snapshots.documents
//
//        for document in mapData {
//            let workoutName: String = document.data()["workoutName"] as! String
//            let targetPart: TargetPart = TargetPartUtils.toTargetPart(document.data()["targetPart"] as! String)
//            let doneAt: Timestamp = document.data()["doneAt"] as! Timestamp
//            let weight: Double = document.data()["weight"] as! Double
//            let reps: Double = document.data()["reps"] as! Double
//            let volume: Double = document.data()["volume"] as! Double
//
//            let data = WorkoutModel(doneAt: doneAt, targetPart: targetPart, workoutName: workoutName, weight: weight, reps: reps, volume: volume)
//            workoutArray.append(data)
//        }
//        return workoutArray
//    }
    
    static func getWorkoutFromFirestore(uid: String, dateString: String) async throws -> [WorkoutModel] {
        let db = Firestore.firestore()
        var workoutArray: [WorkoutModel] = []
        guard let uid = Auth.auth().currentUser?.uid else { return workoutArray }
        
        let snapshot = try await  db.collection("users").document(uid).collection("workout").document(dateString).getDocument(source: .default)
        guard let mapData = snapshot.data() else { return workoutArray }
        if mapData.count == 0 {
            return workoutArray
        } else {
            for i in 0..<mapData.count {
                if let valueData = mapData.values as? [[String: Any]] {
                    let workoutName: String = valueData[i]["workoutName"] as! String
                    let targetPart: TargetPart = TargetPartUtils.toTargetPart(valueData[i]["targetPart"] as! String)
                    let doneAt: Timestamp = valueData[i]["doneAt"] as! Timestamp
                    let weight: Double = valueData[i]["weight"] as! Double
                    let reps: Int = valueData[i]["reps"] as! Int
                    let volume: Double = valueData[i]["volume"] as! Double
                    
                    let data = WorkoutModel(doneAt: doneAt, targetPart: targetPart, workoutName: workoutName, weight: weight, reps: reps, volume: volume)
                    workoutArray.append(data)
                }
            }
        }
        return workoutArray
    }
}
