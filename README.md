# Nykaa 营销活动效果分析

> 印度美妆电商 **Nykaa** 的营销活动（Campaign）全链路效果分析。
> 覆盖 **数据清洗 → ROI 驱动因素回归 → 多维漏斗 SQL 分析 → Tableau 可视化看板** 的完整分析流水线。

---

## 一、项目简介

本项目以一份包含 **55,555 条营销活动记录、26 个字段** 的数据集为基础，回答以下业务问题：

- 哪类活动（Campaign_Type）、哪个受众（Target_Audience）、哪种客户分群（Customer_Segment）的 **ROI 更高**？
- 曝光 → 点击 → 线索 → 成交 的 **转化漏斗** 在不同维度上表现如何？
- 哪些 **渠道（Channel）与人群组合** 最赚钱？
- ROI 受哪些因素驱动？（用多元线性回归量化）

技术栈：Python（pandas / statsmodels）+ MySQL + Tableau。

---

## 二、数据说明

### 原始数据 `data/nykaa_campaign_data.csv`
每行代表一次营销活动，核心字段：

| 字段 | 说明 |
| --- | --- |
| `Campaign_ID` | 活动唯一编号 |
| `Date` | 活动日期 |
| `Campaign_Type` | 活动类型（Social Media / Paid Ads / Influencer / Email / SEO） |
| `Target_Audience` | 目标受众 |
| `Channel_Used` | 投放渠道（**多值字段**，如 `"Social Media, Email"`） |
| `Language` | 投放语言 |
| `Customer_Segment` | 客户分群 |
| `Duration` | 活动周期（天） |
| `Impressions` / `Clicks` / `Leads` / `Conversions` | 漏斗四层：曝光 / 点击 / 线索 / 成交 |
| `Revenue` | 收入 |
| `Acquisition_Cost` | 获客成本 |
| `ROI` | 投资回报率（= 收入 / 成本，可为负） |
| `Engagement_Score` | 互动得分 |

### 清洗后数据 `data/nykaa_campaign_cleaned.csv`
经 `src/nykaa_analysis.py` 处理后 **55,555 行 × 26 列**，新增 9 个衍生指标：
`CTR`、`Click_to_Lead_Rate`、`Lead_to_Conv_Rate`、`Overall_Conv_Rate`、`CPC`、`CPA`、`Revenue_per_Conv`、`Profit`、`Year_Month`。

> 清洗日志见 `data/data_cleaning_log.txt`：0 缺失、0 重复、0 负值、0 逻辑矛盾（Clicks≤Impressions 等），质量良好。

---

## 三、目录结构

```
nykaa_campaign_analysis/
├── data/                          # 数据层
│   ├── nykaa_campaign_data.csv       # 原始数据
│   ├── nykaa_campaign_cleaned.csv   # 清洗后数据（分析主表）
│   ├── data_cleaning_log.txt         # 清洗过程日志
│   ├── regression_coefficients.csv   # 回归系数表
│   └── model_stats.csv               # 回归整体统计量（R² / F 等）
├── src/                           # 代码层
│   ├── nykaa_analysis.py             # ① 数据载入与清洗 + 衍生指标
│   ├── nykaa_roi_regression.py       # ② ROI 多元线性回归
│   └── tableau_data_prep.py          # ③ 生成 Tableau 数据源
├── sql/                           # 查询层（MySQL 语法）
│   └── nykaa campaign analysis.sql    # 11 条多维漏斗 / KPI 查询
├── output/                        # 成果层
│   ├── nykaa_营销效果分析报告.xlsx      # Excel 综合报告
│   ├── data_sql/                    # SQL 导出的 11 个 CSV
│   └── tableau/                    # Tableau 看板 + 数据源
│       ├── nykaa_Dashboard.twb         # Tableau 工作簿
│       ├── nykaa_Campaigns.xlsx        # 看板配套数据
│       ├── t1_campaign_master.csv      # 活动主表
│       ├── t2_channel_exploded.csv     # 渠道拆分表（约 29 MB）
│       ├── t3_monthly_trend.csv        # 月度趋势
│       └── t4_roi_segments.csv         # ROI 分级分布
├── .gitignore
└── README.md
```

---

## 四、分析流水线

| 步骤 | 脚本 / 文件 | 输入 → 输出 |
| --- | --- | --- |
| ① 清洗 | `src/nykaa_analysis.py` | `nykaa_campaign_data.csv` → `nykaa_campaign_cleaned.csv` + 衍生指标 + 日志 |
| ② 回归 | `src/nykaa_roi_regression.py` | 清洗数据 → `regression_coefficients.csv` / `model_stats.csv` |
| ③ 多维分析 | `sql/nykaa campaign analysis.sql` | 清洗数据（建表）→ `output/data_sql/*.csv` |
| ④ 看板数据 | `src/tableau_data_prep.py` | 清洗数据 → `output/tableau/t1~t4_*.csv` |
| ⑤ 可视化 | `output/tableau/nykaa_Dashboard.twb` | 用 Tableau 打开查看看板 |

---

## 五、核心方法：ROI 回归模型

- **模型**：OLS 多元线性回归（`statsmodels`），因变量 `ROI`。
- **核心自变量**：`Campaign_Type`（活动类型）、`Duration`（活动周期）。
- **控制变量**：`Engagement_Score`、`Acquisition_Cost`（连续）；`Language` / `Target_Audience` / `Customer_Segment`（分类，做哑变量并 `drop_first` 避免多重共线性）。
- **产出**：系数、标准误、t 值、p 值、95% 置信区间、显著性标记（`***/**/*`）；整体 `R²`、`Adj. R²`、`F` 统计量。

---

## 六、SQL 分析内容（共 11 条查询）

| 查询 | 维度 | 内容 |
| --- | --- | --- |
| m1 | 整体 | 全量漏斗 + 总收入/成本/平均 ROI |
| m2 | Campaign_Type | 按活动类型分漏斗 |
| m3 | Target_Audience | 按目标受众分漏斗 |
| m4 | Customer_Segment | 按客户分群分漏斗 |
| m5 | Language | 按语言分漏斗 |
| m6 | Duration | 按活动周期（1-7/8-14/15-21/22-30/30+ 天）分漏斗 |
| m7 | Channel | **多渠道拆分**（递归 CTE 展开 `Channel_Used`）后分漏斗 |
| — | 月度 | 月度趋势（曝光/点击/成交/ROI） |
| — | ROI | ROI 分级分布（亏损/低效/中等/良好/优秀） |
| — | KPI | 总体 KPI 卡片 |
| — | 交叉 | 渠道 × 客户分群 交叉分析 |

> 注意：SQL 采用 **MySQL 语法**（含 `SUBSTRING_INDEX`、`RECURSIVE CTE`、`IF`、`LOCATE` 等），需在 MySQL 中先把 `nykaa_campaign_cleaned.csv` 导入为表 `nykaa_campaign_cleaned` 后运行。

---

## 七、环境依赖与运行

```bash
# Python 依赖
pip install pandas numpy statsmodels

# ① 数据清洗（生成 cleaned 数据）
python src/nykaa_analysis.py

# ② ROI 回归（生成系数与统计量）
python src/nykaa_roi_regression.py

# ③ 生成 Tableau 数据源
python src/tableau_data_prep.py
```

- **SQL**：MySQL 客户端导入清洗后 CSV 为表，再执行 `sql/nykaa campaign analysis.sql`。
- **看板**：用 Tableau Desktop 打开 `output/tableau/nykaa_Dashboard.twb`。

---

## 八、备注

- 本项目数据来自Kaggle公开数据集，仅用于分析方法演示，不含个人隐私信息。
