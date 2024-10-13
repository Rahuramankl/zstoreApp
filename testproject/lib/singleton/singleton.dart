class SingletonData {
  SingletonData.internal();
  static final singleton = SingletonData.internal();

  List addItem = [];

  void reset() {
    return addItem.clear();
  }


  factory SingletonData () {
    return singleton;
  }
}