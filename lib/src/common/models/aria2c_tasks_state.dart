// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aria2cf/aria2cf.dart';
import 'package:equatable/equatable.dart';

class Aria2cfTasksState extends Equatable {
  Aria2cfTasksState._internal();
  static final Aria2cfTasksState _instance = Aria2cfTasksState._internal();

  factory Aria2cfTasksState() {
    return _instance;
  }

  final List<Aria2cTask> activeTasks = [];
  final List<Aria2cTask> waitingTasks = [];
  final List<Aria2cTask> stoppedTasks = [];

  List<Aria2cTask> get allTasks => activeTasks + waitingTasks + stoppedTasks;

  @override
  List<Object> get props => [activeTasks, waitingTasks, stoppedTasks, allTasks];

  Aria2cfTasksState copyWith({
    List<Aria2cTask>? activeTasks,
    List<Aria2cTask>? waitingTasks,
    List<Aria2cTask>? stoppedTasks,
  }) {
    if (activeTasks != null) {
      this.activeTasks.clear();
      this.activeTasks.addAll(activeTasks);
    }
    if (waitingTasks != null) {
      this.waitingTasks.clear();
      this.waitingTasks.addAll(waitingTasks);
    }
    if (stoppedTasks != null) {
      this.stoppedTasks.clear();
      this.stoppedTasks.addAll(stoppedTasks);
    }
    return _instance;
  }
}
