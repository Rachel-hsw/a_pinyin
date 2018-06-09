<!-- CHANGELOG.md, a_pinyin/
-->

# A拼音 更新日志


## a_pinyin version 1.2.0 test20180604 1147

+ 新增功能 (apk/UI): 按键振动, 振动时长可设置, 设为 0 禁用振动

+ 新增功能 (apk): 启用生僻汉字, 除了常用 7,000 汉字之外, 还可输入 Unicode 10.0 标准中收录的 3 万多个生僻汉字

+ 新增功能 (apk): 显示更多数据库信息

+ 新增功能 (apk): 整理 (优化) 用户数据库

+ 新增功能 (apk/UI): 设置界面, 可集中进行多项设置

+ 新增功能 (apk/UI): 自动下载数据库功能改进, 显示提示框 (Alert)

+ 新增功能 (apk/UI): 处理硬件返回按钮

+ 新增功能 (apk/DEBUG): 添加 react-devtools, 调试版 显示 DEV 字样

+ 代码优化: 使用 react-native 的 StyleSheet 定义样式


## a_pinyin version 1.1.0 test20180601 0028

+ 新增功能 (apk/UI): 安装后可自动下载数据库

+ 新增功能 (apk/UI): 首次启动自动请求读写存储权限

+ 新增功能 (apk/UI): 关于界面文本可选择

+ 代码清理


## a_pinyin version 1.0.0 test20180525 0150

+ 发布首个版本

+ 主要功能

  + 非汉字输入: 数字, 大小写英文字母, ASCII 符号, 中文标点等更多常用符号
  + 汉字输入 (拼音输入): 拼音切分, 单个汉字输入, 多字输入 (词组 及 语句 输入)
  + 用户语言模型: 记录 用户输入 的 字/词 等, 学习用户输入特征
  + 无痕模式
  + 用户界面样式: 深色 / 浅色 两种 颜色主题

+ 主要核心模型/算法

  + 马尔可夫模型 / 隐马尔可夫模型 (Hidden Markov Model, HMM), n-best Viterbi 算法
  + 词典 (词频)

+ 主要使用技术

  + react-native
  + Android 输入法框架
  + gradle
  + kotlin
  + coffeescript
  + kryo
  + JSON / klaxon
  + sqlite3
  + HanLP

<!-- end CHANGELOG.md -->
