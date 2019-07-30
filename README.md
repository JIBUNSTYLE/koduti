# koduti

Kuriを参考に作ったiOS用オレオレVIPERジェネレータ。

**Dependencies**
- Package Manager
	- Swift Package Manager
    	- @see https://qiita.com/mono0926/items/e8fdd97115780204f797
- packages
	- .package(url: "https://github.com/bannzai/XcodeProject.git", from: "0.1.5")
    - .package(url: "https://github.com/behrang/YamlSwift.git", from: "3.4.4")
    - .package(url: "https://github.com/kareman/SwiftShell", from: "4.1.2")


## How to build.

```bash
$ git clone git@github.com:JIBUNSTYLE/koduti.git
$ cd koduti
$ swift build
```

動作確認

```bash
$ .build/debug/koduti
```

クリーン

```
$ swift package clean
```

### リリースビルド

```bash
$ swift build -c release
```

## Xcodeプロジェクトがない場合

```bash
$ swift package generate-xcodeproj
generated: ./koduti.xcodeproj
$ open koduti.xcodeproj/
```

## トラブルシューティング

### macOS 10.15-beta

```
$ ./.build/x86_64-apple-macosx/debug/koduti
This copy of libswiftCore.dylib requires an OS version prior to 10.14.4.
Abort trap: 6
```

## How to use it.

iOSプロジェクト（Sampleとする）を作り、プロジェクト配下にkodutiの実行ファイルをコピー。

```bash
$ koduti init
```

これで 

- Sample/System/ViperProtocols.swift
- Sample/koduti.yml
- Sample/templates/*

ができる。


```bash
$ koduti gen ${prefix}
```


で、templates以下のテンプレートが `prefix` を接頭辞に自動生成される。