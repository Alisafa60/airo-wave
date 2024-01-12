import 'package:flutter/material.dart';


class MapsScreen extends StatelessWidget{
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('flutter map'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index){
                return ListTile(
                  title: Text('item ${1+index}'),
                );
              },
              childCount: 20,
            ),
          )
        ],
      ),
    );
  }
}