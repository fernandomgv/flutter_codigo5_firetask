// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  TaskModel({
  required  this.date,
    required    this.description,
    required  this.finished,
    required  this.title,
    required  this.type,
    required  this.id,
  });

  String date;
  String description;
  bool finished;
  String title;
  String type;
  String id;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    date: json["date"].toString(),
    description: json["description"],
    finished: json["finished"],
    title: json["title"],
    type: json["type"],
    id: json["id"]== null ? "" : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "description": description,
    "finished": finished,
    "title": title,
    "type": type,
    "id": id,
  };
}
