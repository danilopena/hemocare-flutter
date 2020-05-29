import 'package:hemocare/models/stock_model.dart';

abstract class IStockRepository {
  Stream<StockModel> getStock();
}
