import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hemocare/models/hemocentro_model.dart';
import 'package:mobx/mobx.dart';

part 'hemocentros_store.g.dart';

class HemocentrosStore = _HemocentrosStore with _$HemocentrosStore;

abstract class _HemocentrosStore with Store {
  _HemocentrosStore() {
    print('was called');
    _loadHemocentros();
  }
  ObservableList<Hemocentro> hemocentros = ObservableList<Hemocentro>();

  @observable
  String search = '';

  @action
  void setSearch(String value) {
    print(value);
    search = value;
  }

  final Firestore firestore = Firestore.instance;

  @action
  Future<void> _loadHemocentros() async {
    firestore
        .collection('hemocentros')
        .snapshots()
        .listen((QuerySnapshot event) {
      for (DocumentSnapshot doc in event.documents) {
        hemocentros.add(Hemocentro.fromJson(doc.data));
      }
    });
  }

  @computed
  List<Hemocentro> get filteredHemocentros {
    if (search.isEmpty || search == null) {
      return hemocentros;
    }
    return hemocentros
        .where((Hemocentro element) =>
            element.state.toLowerCase().contains(search.toLowerCase()) ||
            element.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }
}
