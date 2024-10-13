class RatingViewModel {

  RatingViewModel.internal();

  static final ratingsingleton = RatingViewModel.internal();
  List ratingList = [];

  bool isChecked = false;

  void clear() {
    ratingList.clear();
  }
  factory RatingViewModel(){
    return ratingsingleton;
  }
}
