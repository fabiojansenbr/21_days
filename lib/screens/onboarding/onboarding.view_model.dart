import 'package:scoped_model/scoped_model.dart';

class OnboardingViewModel extends Model {
  int selectedIndex = 0;

  void setIndex(int index) {
    selectedIndex = index;

    // Then notify all the listeners.
    notifyListeners();
  }
}
