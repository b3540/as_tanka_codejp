# "CodeJP"アセンブラ短歌 #

TrelloのCode 2016 企画できんぎょばちにこっそり挙げていた「[アセンブラ短歌](https://trello.com/c/IPriy7pn)」を勝手にやってみました。

	b8 03 00 cd 10
	b3 0f b9 06 00 b8 c0 07
	8e c0 bd 19 00
	b8 01 13 cd 10 eb fe
	43 6f 64 65 4a 50

五・八・五・七・六で、一応、合計三十一バイト(みそひとバイト)です。

## バイナリの内容について ##

上記のバイナリはOSレスでQEMU上に"CodeJP"と表示するプログラムです。

三十一バイトにコード(textセクション)とデータ(dataセクション)を含んでいます。

最後の6バイトがデータで、内容は"CodeJP"のアスキーコードです。

アスキーコード部分を文字で表すと以下のようになり、

	b8 03 00 cd 10
	b3 0f b9 06 00 b8 c0 07
	8e c0 bd 19 00
	b8 01 13 cd 10 eb fe
	'C' 'o' 'd' 'e' 'J' 'P'

「ほにゃららほにゃらら・・CodeJP」と最後に"CodeJP"のアスキー値で締められている所がいい感じかなと思っています。

## 試し方 ##

Makefileを同梱しており、`make run`でビルド・実行が行えます。(要GCC、Make、QEMU)

## as_tanka_codejp.img について ##

最終生成物であり、QEMUが実行する対象である`as_tanka_codejp.img`自体は512バイトあります。

これは、BIOSにディスクの先頭512バイトをMBR(Master Boot Record)である(実行するものである)と認識させるには、先頭から510バイト目に`0xaa55`を配置する必要があるためです。

`as_tanka_codejp.img`の逆アセンブル結果は、以下のコマンドで確認できます。

$ objdump -D -b binary -mi386 -Maddr16,data16 as_tanka_codejp.img

as_tanka_codejp.img:     ファイル形式 binary


	セクション .data の逆アセンブル:
	
	00000000 <.data>:
	   0:   b8 03 00                mov    $0x3,%ax
	   3:   cd 10                   int    $0x10
	   5:   b3 0f                   mov    $0xf,%bl
	   7:   b9 06 00                mov    $0x6,%cx
	   a:   b8 c0 07                mov    $0x7c0,%ax
	   d:   8e c0                   mov    %ax,%es
	   f:   bd 19 00                mov    $0x19,%bp
	  12:   b8 01 13                mov    $0x1301,%ax
	  15:   cd 10                   int    $0x10
	  17:   eb fe                   jmp    0x17
	  19:   43                      inc    %bx
	  1a:   6f                      outsw  %ds:(%si),(%dx)
	  1b:   64 65 4a                fs gs dec %dx
	  1e:   50                      push   %ax
	        ...
	 1fb:   00 00                   add    %al,(%bx,%si)
	 1fd:   00 55 aa                add    %dl,-0x56(%di)
- CPU起動直後のモードであるリアルモード(16ビットモード)の実行バイナリなので、`objdump`に16ビットとして認識させるオプションを付けています

`as_tanka_codejp.S`を見るとわかりますが、`jmp    0x17`がアセンブラのコードの最後で、それ以降はアスキーコードを`objdump`が無理やり命令として逆アセンブルしています。

データの最後である`'P'(0x50)`までで`0x1f(31)`であり、一応、三十一バイトに収まっています。
