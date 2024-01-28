import 'package:dto/user.dart';

class Event {
  final String adresse;
  final String? theme;
  final String nom;
  final User host;
  final List<String> invited;
  final List<String>? present;
  final List<String>? absent;
  final DateTime date;
  final List<String>? brings;

  Event({
    required this.adresse,
    this.theme,
    required this.nom,
    required this.host,
    required this.invited,
    this.present,
    this.absent,
    required this.date,
    this.brings,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      adresse: json['adresse'],
      theme: json['theme'],
      nom: json['nom'],
      host: User.fromJson(json['host']),
      invited: json['invited'] == null ? [] : json['invited'].cast<String>(),
      present: json['present'] == null ? [] : json['present'].cast<String>(),
      absent: json['present'] == null ? [] : json['present'].cast<String>(),
      date: json['date'].toDate(),
      brings: json['brings'] == null ? [] : json['brings'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adresse': adresse,
      'theme': theme,
      'nom': nom,
      'host': host.toJson(),
      'invited': invited.toList(),
      'present': present != null ? present!.toList() : [],
      'absent': absent != null ? absent!.toList() : [],
      'date': date,
      'brings':  brings != null ? brings!.toList() : [],
    };
  }
}
