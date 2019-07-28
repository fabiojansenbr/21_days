import 'package:scoped_model/scoped_model.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';
import 'package:twenty_one_days/utilities/storage_helper.dart';

class GoalsListViewModel extends Model {
  List<Goal> goals;
  GoalsListViewModel() {
    _fetchData();
  }

  Future<void> _fetchData() async {
    goals = await StorageHelper().fetchGoals();
    notifyListeners();
  }

  Future<void> addNewGoal(Goal goal) async {
    try {
      await StorageHelper().addGoal(goal);
      goals.add(goal);
      notifyListeners();
    } catch (_) {
      print('Error Occured');
    }
  }

  removeGoal(Goal goal) {
    goals.remove(goal);
    notifyListeners();
  }
}
