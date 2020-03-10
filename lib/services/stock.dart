import 'package:dio/dio.dart';
import 'package:hemocare/services/local_storage.dart';

class StockHandler {
  final localStorage = new LocalStorageWrapper();

  Future getStock() async {
    String id = localStorage.retrieve("logged_id");
    Response response = await Dio().get(
      "https://hemocare-backend.herokuapp.com/api/stock/getStock",
      queryParameters: {"userId": id},
    );
    return response;
  }

  Future createStock(String initialStock, String commonDosage) async {
    String id = localStorage.retrieve("logged_id");
    Response response = await Dio().post(
        "https://hemocare-backend.herokuapp.com/api/stock/create",
        queryParameters: {"userId": id},
        data: {"initialStock": initialStock, "dosage": commonDosage});
    return response;
  }
}
