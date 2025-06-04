import 'package:docu_ai_app/models/person.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';

final personProvider =
    StateNotifierProvider<PDFNotifier, Person?>((ref) => PDFNotifier());

class PDFNotifier extends StateNotifier<Person?> {
  PDFNotifier() : super(null);

  Account initialiseAccount() {
    Client client =
        Client().setEndpoint("https://fra.cloud.appwrite.io/v1").setProject("");
    Account account = Account(client);
    return account;
  }

  Future<void> loginWithGoogle() async {
    final prefs = await SharedPreferences.getInstance();
    final account = initialiseAccount();

    await account.createOAuth2Session(
      provider: OAuthProvider.google,
    );

    final user = await account.get();

    await prefs.setString(
      'user_name',
      user.name,
    );
    await prefs.setString(
      'user_email',
      user.email,
    );

    state = Person(name: user.name, email: user.email);
  }
}
