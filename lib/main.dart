import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SafeArea(child: MyHomePage()),
    );
  }
}

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _text = useState<String>("下のボタンをクリックしてね");
    // Streamの初期化
    final _stream =
        textStream(); //* ここで_streamにtextStream()を代入することで、Streamが生成される

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //* 中央に寄せる
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_text.value),
            ),
            FloatingActionButton(
              onPressed: () async {
                print("ボタンがクリックされました！");
                _text.value = "";
                await for (final currentText in _stream) {
                  print("currentText: $currentText");
                  _text.value += currentText;
                }
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    ));
  }
}

const fullText = 'Streamでテキストを1文字ずつ出力するサンプル。';

/// テキストを一定間隔で1文字ずつ出力するStream
Stream<String> textStream() async* {
  for (var i = 0; i < fullText.length; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 100)); //* 100ミリ秒待つ
    yield fullText[i];
  }
}


// はい、その通りです。`await for (final currentText in _stream)` の代わりに `await for (final currentText in textStream())` を使用することもできます。どちらも同じ `Stream` を処理することになります。

// ただし、`_stream` 変数を使用することで、`textStream()` を複数回呼び出す必要がなくなり、コードが少し読みやすくなる場合があります。

// 以下はその例です：

// ```dart
// FloatingActionButton(
//   onPressed: () async {
//     print("ボタンがクリックされました！");
//     _text.value = "";
//     await for (final currentText in textStream()) {
//       print("currentText: $currentText");
//       _text.value += currentText;
//     }
//   },
//   child: const Icon(Icons.add),
// );
// ```