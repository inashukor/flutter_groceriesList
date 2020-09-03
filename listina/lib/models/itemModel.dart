import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String title;
  DateTime startDate;
  double budget;
  Map budgetTypes;
  String listType;
  String notes;
  String documentId;
  double saved;

  Item(
    this.title,
    this.startDate,
    this.budget,
    this.budgetTypes,
    this.listType,
  );

  //////////format untuk upload ke firebase///////
  Map<String, dynamic> toJson() => {
        'title': title,
        'startDate': startDate,
        'budget': budget,
        'budgetTypes': budgetTypes,
        'listType': listType,
      };

  /////////////// create item object from firebase snapshot
  Item.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        startDate = snapshot['startDate'].toDate(),
        budget = snapshot['budget'],
        budgetTypes = snapshot['budgetTypes'],
        listType = snapshot['listType'],
        notes = snapshot['notes'],
        documentId = snapshot.documentID,
        saved = snapshot['saved'];

  Map<String, Icon> types() => {
        "grocery": Icon(
          Icons.shopping_basket,
          size: 50,
        ),
        "food": Icon(
          Icons.local_dining,
          size: 50,
        ),
        "event": Icon(
          Icons.notifications_active,
          size: 50,
        ),
        "school": Icon(
          Icons.location_city,
          size: 50,
        ),
        "work": Icon(
          Icons.work,
          size: 50,
        ),
        "other": Icon(
          Icons.favorite,
          size: 50,
        ),
      };

  //////get days until start date///
  int getDaysUntilDate() {
    int diff = startDate.difference(DateTime.now()).inDays;
    if (diff < 0) {
      diff = 0;
    }
    return diff;
  }
}
