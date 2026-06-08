import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/learning/stage.dart';

class LearningStageService {
  const LearningStageService();

  Future<List<Stage>> fetchStages() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('learning_stages')
        .orderBy(FieldPath.documentId)
        .get(const GetOptions(source: Source.serverAndCache));
    return snapshot.docs.map((doc) => Stage.fromJson(doc.data())).toList();
  }

  Future<void> seedDefaultContent(List<Stage> defaultStages) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final stage in defaultStages) {
      batch.set(
        FirebaseFirestore.instance.collection('learning_stages').doc(stage.id),
        stage.toJson(),
      );
    }
    await batch.commit();
  }
}
