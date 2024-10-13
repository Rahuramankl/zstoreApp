

import 'package:testproject/zpages/zstore_data.dart';
import 'package:testproject/zpages/zstore_service.dart';

class DataViewModel{

  Data ? data;
  Future loadData() async {
    data = await UserService().getData();
  }
}
