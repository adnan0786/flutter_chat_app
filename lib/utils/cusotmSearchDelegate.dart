import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/chatModel.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<ChatModel> chatList;

  CustomSearchDelegate(this.chatList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear_rounded))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<ChatModel> filteredList = [];
    for (var chat in chatList) {
      if (chat.name!.toLowerCase().contains(query.toLowerCase())) {
        filteredList.add(chat);
      }
    }

    return ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredList[index].name!),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<ChatModel> filteredList = [];
    for (var chat in chatList) {
      if (chat.name!.toLowerCase().contains(query.toLowerCase())) {
        filteredList.add(chat);
      }
    }

    return ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredList[index].name!),
          );
        });
  }
}
