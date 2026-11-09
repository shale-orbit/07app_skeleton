# app_skeleton · 图书浏览三页骨架

> **本项目为课程作业**，用于演示 Flutter 命名路由、参数传递与状态回传。所有数据均为本地模拟数据，不连接任何后端服务，仅供学习交流使用。

一个用 Flutter 实现的图书浏览小应用：首页按分类浏览，进入列表后可按分类过滤、分页加载、长按筛选，点进详情查看完整书目信息，返回时把筛选结果带回首页显示。

---

## 一、实现了什么效果

| 页面 | 效果 |
|---|---|
| 首页 | 2 列网格展示「全部 + 6 个分类」入口；顶部 AppBar 下方有副标题，显示从列表页带回来的筛选条件 |
| 列表页 | 按分类过滤书目；每页 20 条，「加载更多」每次追加 20 条，加载完显示「已全部加载」；长按任意条目弹出底部筛选面板 |
| 详情页 | 展示一本图书的 7 个字段（编号、书名、分类、作者、评分、借阅次数、入馆月份），底部「返回」按钮返回列表 |
| 关于页 | 说明本项目用途与路由结构，作为第 4 条命名路由的演示入口 |

用起来是这样的：

1. 首页点「全部」→ 看到 20 条书目 + 底部「加载更多（还有 16 条）」；
2. 点「加载更多」→ 变成 36 条，底部变为「已全部加载」；
3. 长按任意一条 → 选「仅看高借阅量（≥50 次）」→ 自动回到首页，副标题出现「当前筛选：仅看高借阅量」；
4. 再点「科普百科」→ 列表只剩 4 条（借阅量 ≥50 的）；
5. 点某本书 → 详情页显示 7 个字段 → 点「返回」回到列表。

---

## 二、用了什么技术

| 技术点 | 具体用法 |
|---|---|
| **命名路由** | `MaterialApp.routes` 注册 4 条路由（`/`、`/list`、`/detail`、`/about`），全项目统一用 `Navigator.pushNamed`，无一处 `MaterialPageRoute` |
| **强类型路由参数** | 自定义 `ListArgs`（分类 + 是否只看高借阅量）与 `Book` 实例作为 `arguments` 传递，用 `is` 做类型判断并给出兜底值 |
| **页面回传值** | 列表页 `Navigator.pop(context, '仅看高借阅量')` 把筛选结果带回首页，首页 `await pushNamed` 接住后 `setState` 更新 AppBar 副标题 |
| **异步数据加载** | `rootBundle.loadString('assets/books.json')` 读取打包资源，`jsonDecode` 转模型；`Future` 存在 `State` 字段中，避免每次重建重复读盘 |
| **FutureBuilder 三态** | 分别处理加载中（转圈）、加载失败（错误文案）、加载完成三种状态 |
| **ListView.builder 分页** | `take(_visible)` 控制当前渲染条数，点「加载更多」时 `setState(() => _visible += 20)` 追加数据 |
| **组件抽取与复用** | `lib/widgets/` 下三个参数化组件：`BookTile`（列表项）、`InfoRow`（详情字段行）、`CategoryTile`（首页分类卡片） |
| **空状态处理** | 过滤后无结果时显示「没有符合条件的图书」，避免白屏 |
| **底部弹层** | `showModalBottomSheet` 实现长按筛选面板，先关闭弹层再关闭列表页，保证导航栈正确 |

数据方面：`assets/books.json` 共 36 条模拟书目，覆盖 6 个分类，每条含 7 个字段。

---

## 三、页面与路由结构

```
HomePage  '/'  ──点分类──▶  BookListPage '/list'  ──点条目──▶  BookDetailPage '/detail'
   │                              │
   │                              └──长按筛选── pop('仅看高借阅量') ──▶ 回首页更新副标题
   │
   └──右上角 ⓘ──▶  AboutPage '/about'
```

对应 `lib/main.dart` 中的路由表：

```dart
initialRoute: '/',
routes: {
  '/': (_) => const HomePage(),
  '/list': (_) => const BookListPage(),
  '/detail': (_) => const BookDetailPage(),
  '/about': (_) => const AboutPage(),
},
```

---

## 四、目录结构

```
lib/
├── main.dart                 # 应用入口与命名路由表
├── book.dart                 # Book 模型 + loadBooks() 读取 assets
├── list_args.dart            # 列表页强类型路由参数
├── home_page.dart            # 首页：分类网格 + AppBar 副标题
├── book_list_page.dart       # 列表页：过滤 + 分页 + 长按弹层
├── book_detail_page.dart     # 详情页：7 个字段 + 返回
├── about_page.dart           # 关于页（第 4 条路由）
└── widgets/
    ├── book_tile.dart        # 列表项组件
    ├── info_row.dart         # 详情字段行组件
    └── category_tile.dart    # 分类卡片组件
assets/
└── books.json                # 36 条模拟书目数据
```

---

## 五、如何运行

### 1. 准备环境

- 安装 **Flutter SDK**（本项目在 Flutter 3.47.4 / Dart 3.13.3 下开发验证）
- 安装 **Git**
- 确认环境可用：

```powershell
flutter --version
flutter doctor
```

`flutter doctor` 里至少有 Windows（或 Chrome）一项通过。

### 2. 获取代码并安装依赖

```powershell
git clone https://github.com/shale-orbit/07app_skeleton.git
cd 07app_skeleton
flutter pub get
```

### 3. 运行

桌面端（推荐，本课验收使用）：

```powershell
flutter run -d windows
```

浏览器端（不想装桌面工具链时）：

```powershell
flutter run -d chrome
```

首次运行需要编译，等 1~3 分钟；窗口出现「图书分类」页面即成功。

### 4. 走一遍验收流程

1. 点「全部」→ 20 条 + 「加载更多（还有 16 条）」；
2. 点「加载更多」→ 36 条 + 「已全部加载」；
3. 长按任意条目 → 选「仅看高借阅量」→ 回首页看副标题变化；
4. 再点「科普百科」→ 4 条；点「计算机技术」→ 无结果提示；
5. 点任意书 → 详情页 7 个字段 → 点「返回」。

---

## 六、常见问题

| 问题 | 原因与处理 |
|---|---|
| 改了 `books.json` 但页面没变化 | 资源文件不会随热重载更新，按大写 `R` 热重启，或重新 `flutter run` |
| 改了 `routes` 后跳转无效 | 路由表在启动时构建，需要热重启（大写 `R`），小写 `r` 热重载不生效 |
| 启动报错 `home` 与 `routes['/']` 冲突 | `home` 与 `routes` 中的 `'/'` 只能二选一，本项目统一用 `initialRoute` |
| `flutter run -d windows` 提示缺少工具链 | 需要安装 Visual Studio 的「使用 C++ 的桌面开发」工作负载；或改用 `-d chrome` |
| 提示 `No tests ran` | 本项目的默认计数器测试已删除，属正常现象；`flutter analyze` 零 issue 即为通过 |

---

## 七、声明

本项目为**课程作业**，基于《Flutter 实战·第二版》相关章节与课堂讲义完成，仅用于学习演示：

- 数据为本地模拟数据，不涉及真实图书系统；
- 不用于生产环境，不保证业务正确性与安全性；
- 欢迎交流学习，请勿直接用于商业用途。
