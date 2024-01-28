import 'package:dto/event.dart';
import 'package:dto/user.dart';
import 'package:firedart/firedart.dart';
import 'package:push_data_to_firebase/events.dart';
import 'package:push_data_to_firebase/users.dart';

String pi = "";
String apiKey = "";

void main(List<String> arguments) async {
  Firestore.initialize(pi);
  late TokenStore tokenStore;

  tokenStore = VolatileStore();
  FirebaseAuth(apiKey, tokenStore);
  FirebaseAuth.initialize(apiKey, tokenStore);
  await addUsers();
  await addEvents();


  return null;
}

Future<void> addUsers() async {
  for (User user in users) {
    await Firestore.instance
        .collection('users')
        .add(user.toJson())
        .then((value) {
      print('Event added with ID: ${value.id}');
    }).catchError((error) {
      print('Failed to add event: $error');
    });
  }
}

Future<void> addEvents() async {
  for (Event event in events) {
    await Firestore.instance
        .collection('events')
        .add(event.toJson())
        .then((value) {
      print('Event added with ID: ${value.id}');
    }).catchError((error) {
      print('Failed to add event: $error');
    });
  }
}

