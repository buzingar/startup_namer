import 'package:flutter/material.dart';
// 引入 english_words 依赖包
import 'package:english_words/english_words.dart';

// => 单行函数或方法的简写，runApp接收一个widget实例
void main() => runApp(new MyApp());

// 继承了 StatelessWidget，使应用本身也成为一个widget
// Stateless widgets 是不可变的, 这意味着它们的属性不能改变 - 所有的值都是最终的.
class MyApp extends StatelessWidget {
  // widget的主要工作是提供一个build()方法来描述如何根据其他较低级别的widget来显示自己
  // 描述如何显示
  // 根据低级别widget
  @override
  Widget build(BuildContext context) {
    // 生成单词对
    // final wordPair = new WordPair.random();

    //return new MaterialApp(
    //  //标题
    //  title: 'Flutter APP',
    //  //Scaffold 是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性
    //  home: new Scaffold(
    //    //导航栏
    //    appBar: new AppBar(
    //      //标题
    //      title: new Text('Welcome to First Flutter'),
    //    ),
    //    //主体，居中，Center widget可以将其子widget树对其到屏幕中心。
    //    body: new Center(
    //      //文本widgets
    //      // child: new Text('Hello World，I am a new flutter app created by Gornin.'),
    //      // child: new Text(wordPair.asPascalCase),
    //      child: new RandomWords(),
    //    ),
    //  ),
    //);

    return new MaterialApp(
      title: 'Startup Name Generator',
      // 修改主题
      theme: new ThemeData(
        primaryColor: Colors.pink,
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  // 保存建议的单词对
  // 该变量以下划线（_）开头，在Dart语言中使用下划线前缀标识符，会强制其变成私有的。
  final _suggestions = <WordPair>[];
  // 存储用户喜欢（收藏）的单词对，Set中不允许重复的值。
  final _saved = new Set<WordPair>();
  // 添加一个biggerFont变量来增大字体大小
  final _biggerFont = const TextStyle(fontSize: 12.0);

  @override
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    // return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Names Generator'),
        // 列表图标
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    // 添加MaterialPageRoute及其builder
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          // ListTile的divideTiles()方法在每个ListTile之间添加1像素的分割线。
          // 该 divided 变量持有最终的列表项。
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          /*
          * builder返回一个Scaffold，其中包含名为“Saved Suggestions”的新路由的应用栏。
          * 新路由的body由包含ListTiles行的ListView组成;
          * 每行之间通过一个分隔线分隔。
          * */
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  // 对于每一个单词对，_buildSuggestions函数都会调用一次_buildRow。
  // 此方法构建显示建议单词对的ListView
  Widget _buildSuggestions() {
    // ListView类提供了一个builder属性，
    // itemBuilder 值是一个匿名回调函数， 接受两个参数- BuildContext和行迭代器i。
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) return new Divider();

          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
          final index = i ~/ 2;
          // 如果是建议列表中最后一个单词对
          if (index >= _suggestions.length) {
            // ...接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    // 判断当前单词对是否已被添加
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
