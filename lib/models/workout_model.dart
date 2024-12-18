import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutModel {
  QueryDocumentSnapshot queryDocumentSnapshot;
  bool isSelected;

  WorkoutModel({
    required this.queryDocumentSnapshot,
    required this.isSelected,
  });
}
