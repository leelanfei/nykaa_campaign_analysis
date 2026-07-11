# 上传本项目到 GitHub —— 分步操作指南

> 适用对象：想把 `nykaa_campaign_analysis` 整个文件夹上传到 GitHub 的用户
> 推荐方式：**GitHub Desktop**（因为本项目含 29.2 MB 大文件，网页上传单文件上限仅 25 MB）
> 环境已检查：本机未安装 git，但以下步骤用图形化工具，无需命令行。

---

## 〇、先确认两件事

1. **是否已注册 GitHub 账号？**
   没有的话先去 https://github.com 注册（免费）。
2. **GitHub Desktop 装了没？**
   下载地址：https://desktop.github.com/
   没装就先装（Windows 一键安装）。

---

## 一、在 GitHub 上新建仓库（远程）

1. 登录 GitHub，点击右上角 **“+” → New repository**。
2. Repository name 填写：`nykaa_campaign_analysis`（建议与文件夹同名）。
3. 可写一句 Description：`Nykaa 营销活动效果分析（数据清洗/ROI回归/SQL漏斗/Tableau看板）`。
4. 选 **Public**（公开）或 **Private**（私有，仅自己可见）。
5. ⚠️ **不要**勾选 "Add a README file" / "Add .gitignore" / "Add license" —— 因为本项目本地已经有 `README.md` 和 `.gitignore`，勾了会冲突。
6. 点击 **Create repository**。
7. 创建后页面会显示一个仓库地址，类似：
   `https://github.com/你的用户名/nykaa_campaign_analysis.git`
   先留着，下一步要用。

---

## 二、用 GitHub Desktop 上传（推荐，支持大文件）

1. 打开 **GitHub Desktop** → 菜单 **File → Add Local Repository**。
2. 选择文件夹：`C:\Users\李晓冉\Desktop\nykaa_campaign_analysis`
   （如果提示 "This directory does not appear to be a Git repository"，点 **Create a repository** 或 **Add**，按提示初始化即可。）
3. 左上角 **Current Repository** 确认是本项目；右上角 **Publish repository**（首次推送到 GitHub）。
4. 在弹窗里：
   - Name：`nykaa_campaign_analysis`
   - Description：可填可不填
   - 选择 **Keep this code private**（私有）或取消勾选（公开）
   - 点 **Publish repository**
5. 等待上传完成（含 29 MB 大文件也能传，进度条走完即可）。
6. 完成后去 GitHub 网页刷新，就能看到整个项目了。

> 之后如果改了代码想更新：在 GitHub Desktop 里写个 Summary（如"更新分析脚本"）→ 点 **Commit to main** → 再点 **Push origin** 即可。

---

## 三、用网页上传（仅当你确认没有超过 25 MB 的文件时）

> ⚠️ 本项目 `output/tableau/t2_channel_exploded.csv` 为 29.2 MB，**网页传不了它**。
> 若坚持用网页，请先按下方"大文件处理"把它排除，否则上传会失败。

1. 在 GitHub 新建好空仓库（见"一"）。
2. 仓库页面点 **Add file → Upload files**。
3. 把 `nykaa_campaign_analysis` 文件夹里的**所有内容**拖进去（注意是文件夹内的内容，不是文件夹本身；或直接在文件夹里全选拖拽）。
4. 下方填个提交说明，如 `initial commit`。
5. 点 **Commit changes**。

---

## 四、大文件处理（重要）

| 文件 | 大小 | 网页上传 | GitHub Desktop |
| --- | --- | --- | --- |
| output/tableau/t2_channel_exploded.csv | 29.2 MB | ❌ 超限失败 | ✅ 可传 |
| data/nykaa_campaign_cleaned.csv | 12.7 MB | ✅ | ✅ |
| output/tableau/t1_campaign_master.csv | 12.4 MB | ✅ | ✅ |
| output/nykaa_营销效果分析报告.xlsx | 11.1 MB | ✅ | ✅ |
| output/tableau/nykaa_Campaigns.xlsx | 8.7 MB | ✅ | ✅ |
| data/nykaa_campaign_data.csv | 7.5 MB | ✅ | ✅ |

**结论：直接用 GitHub Desktop，全部文件都能一次传完，最省事。**

如果你想用网页上传，临时把 `.gitignore` 里这几行取消注释（告诉自己先别传大文件），或手动删除/移走那个 29 MB 文件：
```
data/nykaa_campaign_cleaned.csv
data/nykaa_campaign_data.csv
output/tableau/t2_channel_exploded.csv
output/tableau/t1_campaign_master.csv
```
> 超过 100 MB 的文件 GitHub 会直接拒绝；50–100 MB 会提示用 Git LFS。本项目最大 29 MB，无需 LFS。

---

## 五、已自动帮你排除的文件（不用管）

本项目根目录已生成 `.gitignore`，会自动忽略以下内容，避免把垃圾传上去：
- `.workbuddy/`（WorkBuddy 内部配置与记忆，含隐私，**绝不外传**）
- `__pycache__/`、`*.pyc`（Python 缓存）
- `~Nykaa_Dashboard__26424.twbr`、`*.twbr`（Tableau 临时锁文件）
- `Thumbs.db`、`*.tmp` 等系统临时文件

---

## 六、验证是否上传成功

1. 打开 `https://github.com/你的用户名/nykaa_campaign_analysis`。
2. 确认能看到：`README.md`、`.gitignore`、`data/`、`src/`、`sql/`、`output/`。
3. 确认 **看不到** `.workbuddy/` 文件夹（被 gitignore 挡住了，正确）。
