class User {
  final String email;
  final String nom;
  final String prenom;

  const User({
    required this.email,
    required this.nom,
    required this.prenom,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      nom: json['nom'],
      prenom: json['prenom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'nom': nom,
      'prenom': prenom,
    };
  }
}
