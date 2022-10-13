function main(args)
*ファイルを開く
'open DATA/kanji/wrfout/wrfout_base/base_08.ctl'

*背景色の設定
'set display color white'
'c'

*解像度の設定
'set mpdset hires'

*ドメインの設定
'set lon 135.0 136.0'
'set lat 34.2 35.0'
'set poli on'

*出力データの設定（t:時刻, t2:気温）
*t=64~807　(31日:807, 30日:783, 29日:759, 28日:735)
's = ave(t2-273.15, t=70, t=138, 24)'

*カラーバーの設定
'set clevs'
'color 20 36 1 -kind blue->green->yellow->red'

*描写方法の設定
'set gxout shaded'
'display s'
'cbarn.gs'
'set gxout contour'
'set cint 2'
'set frame off'
'set grid off'
'set xlab off'
'set ylab off'

*描写する
'display s'

*保存
'draw title August 14:00'
'printim T_base_0806.png'
