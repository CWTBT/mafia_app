class User {
  final String name;
  final String ipAddr;
  bool isAlive = true;
  String role;

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        ipAddr = json['ipAddr'],
        isAlive = json['isAlive'],
        role = json['role'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'ipAddr': ipAddr,
        'isAlive': isAlive,
        'role': role
      };

  String toString() {
    return name;
  }
  
  User(this.name, this.ipAddr);
}