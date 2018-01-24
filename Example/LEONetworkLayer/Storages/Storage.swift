import RxSwift


protocol UserProfileStorage {
    func save(profile: UserProfile)
}


class RealmStorage {
    
}



extension RealmStorage: UserProfileStorage {

    func save(profile: UserProfile) {
  
    }

}




