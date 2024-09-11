import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class AppwriteService {
  Client client = Client();
  late Account account;
  late Databases databases;

  AppwriteService() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('66e07a3d002532cdf9ef');

    account = Account(client);
    databases = Databases(client);
  }


  Future<models.User?> signUp(String email, String password) async {
    try {
      final user = await account.create(
        userId: 'unique()',
        email: email,
        password: password,
      );
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }


  Future<models.Session?> login(String email, String password) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return session;
    } catch (e) {
      print(e);
      return null;
    }
  }


  Future<void> logout() async {
    try {
      await account.deleteSessions();
    } catch (e) {
      print(e);
    }
  }


  Future<void> createDietPlan(String meal, String calories) async {
    try {
      await databases.createDocument(
        databaseId: '66e1514a0009c3d8e0fb',
        collectionId: '66e15154000724861c05',
        documentId: 'unique()',
        data: {
          'meal': meal,
          'calories': calories,
        },
        permissions: [
          Permission.read(Role.users()),
          Permission.write(Role.users()),
        ],
      );
    } catch (e) {
      print('Error creating diet plan: $e');
    }
  }


  Future<List<Map<String, dynamic>>> fetchDietPlans() async {
    try {
      final response = await databases.listDocuments(
        databaseId: '66e1514a0009c3d8e0fb',
        collectionId: '66e15154000724861c05',
      );
      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      print('Error fetching diet plans: $e');
      return [];
    }
  }


  Future<void> saveRating(double rating, String feedback) async {
    try {
      await databases.createDocument(
        databaseId: '66e1514a0009c3d8e0fb',
        collectionId: '66e15ca8003c933d2d18',
        documentId: 'unique()',
        data: {
          'rating': rating,
          'feedback': feedback,
        },
        permissions: [
          Permission.read(Role.users()),
          Permission.write(Role.users()),
        ],
      );
    } catch (e) {
      print('Error saving rating: $e');
    }
  }


  Future<List<Map<String, dynamic>>> fetchRatings() async {
    try {
      final response = await databases.listDocuments(
        databaseId: '66e1514a0009c3d8e0fb',
        collectionId: '66e15ca8003c933d2d18',
      );
      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      print('Error fetching ratings: $e');
      return [];
    }
  }
}
