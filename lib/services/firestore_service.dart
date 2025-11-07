import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/instituicao_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Instituicao>> getInstituicoes() {
    return _db.collection('instituicoes').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => Instituicao.fromFirestore(doc))
        .toList());
  }
}