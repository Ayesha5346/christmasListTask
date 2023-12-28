
class ChristmasEntry {
  String name, country, status;
  ChristmasEntry(
      {required this.name, required this.country, required this.status});

  void updateStatus(String val) {
    status = val;
  }

  factory ChristmasEntry.fromFirestore(
    Map<String, dynamic> data,
    // SnapshotOptions? options,
  ) {
    // final data = snapshot.data();
    return ChristmasEntry(
        name: data['name'], country: data['country'], status: data['status']);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'country': country, 'status': status};
  }
}
