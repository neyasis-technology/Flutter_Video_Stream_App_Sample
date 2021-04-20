class UserResponseBM {
  final String id;
  final String clientId;
  final String name;

  UserResponseBM({
    required this.clientId,
    required this.id,
    required this.name,
  });

  factory UserResponseBM.fromJSON(dynamic response) {
    return UserResponseBM(
      clientId: response["clientId"] ?? "",
      id: response["id"] ?? "",
      name: response["name"] ?? "",
    );
  }
}
