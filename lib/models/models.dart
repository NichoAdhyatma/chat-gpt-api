class Models {
  final String id;
  final int create;
  final String root;

  Models({
    required this.id,
    required this.create,
    required this.root,
  });

  factory Models.fromJson(Map<String, dynamic> json) => Models(
        id: json["id"],
        create: json["created"],
        root: json["root"],
      );

  static List<Models> modelsFromSnapshot(List modelsSnapshot) =>
      modelsSnapshot.map((data) => Models.fromJson(data)).toList();
}
