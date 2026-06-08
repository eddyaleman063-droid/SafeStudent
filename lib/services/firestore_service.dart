import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._();
  FirestoreService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  static const _collection = 'users';

  Future<void> createUserProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required int age,
  }) async {
    await _db.collection(_collection).doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': age,
      'totalXp': 0,
      'gemsBalance': 0,
      'currentStreak': 0,
      'longestStreak': 0,
      'lastLoginDate': FieldValue.serverTimestamp(),
      'onboardingCompleted': true,
    });
  }

  Future<void> updateField(String uid, String field, dynamic value) {
    return _db.collection(_collection).doc(uid).update({field: value});
  }

  Future<void> updateFields(String uid, Map<String, dynamic> data) {
    return _db.collection(_collection).doc(uid).update(data);
  }

  Stream<DocumentSnapshot> streamUserDoc(String uid) {
    return _db.collection(_collection).doc(uid).snapshots();
  }
}
