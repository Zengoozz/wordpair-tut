import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, item) {
        if (item.isOdd) {
          return Divider(
            color: Colors.blueGrey[600],
          );
        }
        final index = item ~/ 2;

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget buildRow(WordPair pair) {
    final alreadySaved = _savedWordPairs.contains(pair) ? true : false;

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor),
        textAlign: TextAlign.left,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite_outlined : Icons.favorite_border,
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedWordPairs.map((pair) {
        return ListTile(
            title: Text(
          pair.asPascalCase,
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).accentColor),
        ));
      });
      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[300],
          title: Text(
            'Saved WordPairs',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).primaryColorDark),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Random Words',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).accentColor),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.list),
          )
        ],
      ),
      body: buildList(),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}
