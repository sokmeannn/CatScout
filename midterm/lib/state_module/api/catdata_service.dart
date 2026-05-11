import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'catdata_model.dart';

class CatService {
  Future<List<CatData>> readCats() async {
    try {
      http.Response response = await http.get(
        Uri.parse(
          "https://api.thecatapi.com/v1/images/search?limit=100&has_breeds=1&api_key=live_uQgeyRuvQAOwb3F93dK6IA9NsYOSyFevWL0mva0exZyQ1JfKS7a9P2q8HRfvXW3f",
        ),
      );
      if (response.statusCode == 200) {
        List<CatData> allItems = await compute(catDataFromJson, response.body);
        return allItems;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
