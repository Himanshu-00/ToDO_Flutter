import 'package:get/get.dart';
import '../models/task.dart';
import '../services/database_service.dart';

class TaskViewModel extends GetxController {
  var tasks = <Task>[].obs;
  var filteredTasks = <Task>[].obs;
  var sortedBy = 'Due Date'.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    fetchTasks();
    super.onInit();
  }

  void fetchTasks() async {
    tasks.value = await DatabaseService().getTasks();
    sortTasks();
  }

  void searchTasks(String query) {
    searchQuery.value = query;
    applyFilterAndSort();
  }

  void applyFilterAndSort() {
    if (searchQuery.value.isEmpty) {
      filteredTasks.value = List.from(tasks);
    } else {
      filteredTasks.value = tasks.where((task) {
        return task.title
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            task.description
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    if (sortedBy.value == 'Priority') {
      filteredTasks.sort((a, b) => b.priority.compareTo(a.priority));
    } else {
      filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }
  }

  void sortTasks() {
    if (sortedBy.value == 'Priority') {
      tasks.sort((a, b) => b.priority.compareTo(a.priority));
    } else {
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }

    filteredTasks.value = List.from(tasks);
  }

  void setSorting(String criteria) {
    sortedBy.value = criteria;
    sortTasks();
  }

  void addTask(Task task) async {
    await DatabaseService().insertTask(task);
    fetchTasks();
  }

  void updateTask(Task task) async {
    await DatabaseService().updateTask(task);
    fetchTasks();
  }

  void deleteTask(int id) async {
    await DatabaseService().deleteTask(id);
    fetchTasks();
  }
}
