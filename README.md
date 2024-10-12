# ToDo App

This is a **ToDo App** built with Flutter and GetX, providing users with the ability to manage tasks by adding, editing, searching, and sorting based on due date or priority. This app connects to a local database for storing tasks and offers a clean, responsive UI with various features.


## Features

- Add, edit, and delete tasks.
- Search for tasks by title or description.
- Sort tasks by due date or priority.
- Simple, clean user interface using Flutter and GetX for state management.

---

## App Architecture

This app follows the **MVVM (Model-View-ViewModel)** architecture using `GetX` for state management and dependency injection. The architecture separates the user interface (View) from the business logic (ViewModel), ensuring better code management and testing.

---

## Project Structure

```bash
.
├── main.dart
├── models
│   └── task.dart
├── services
│   └── database_service.dart
├── viewmodels
│   └── task_viewmodel.dart
└── views
    ├── task_edit_view.dart
    └── task_list_view.dart
```

## Screens

[Watch Demo Video](lib/ToDo_Task.mov)




### Task List View

This screen displays a list of tasks, allowing users to:

- View tasks and their details (title, description, due date).
- Search tasks using a search bar.
- Sort tasks by due date or priority using a menu option.
- Tap on a task to edit it or delete it directly from the list.

### Task Edit View

This screen is used for:

- Editing an existing task or adding a new one.
- Setting the task's title, description, priority, and due date.

---

## Models

### Task Model

The `Task` model represents a single task with the following fields:

- **id**: Unique identifier for the task.
- **title**: Title of the task.
- **description**: Description of the task.
- **dueDate**: Due date of the task.
- **priority**: Priority of the task (High, Medium, Low).

---

## ViewModels

### Task ViewModel

The `TaskViewModel` manages the state of the tasks and handles the logic for:

- Fetching tasks from the database.
- Sorting tasks by due date or priority.
- Searching for tasks based on a query.
- Adding, updating, and deleting tasks.

---

## Services

### Database Service

The `DatabaseService` handles communication with the database for tasks. It includes:

- `getTasks`: Fetches all tasks from the database.
- `insertTask`: Adds a new task to the database.
- `updateTask`: Updates an existing task in the database.
- `deleteTask`: Deletes a task from the database by ID.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/task-management-app.git
   ```

## Usage
- To run the app on an emulator or a physical device:
```bash
flutter run
```
## Dependencies
- Flutter: The framework for building the UI.
- GetX: For state management and dependency injection.
- Sqflite: For local SQLite database management.
