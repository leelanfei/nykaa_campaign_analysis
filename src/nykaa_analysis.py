# %% [markdown]
# # 数据载入与清洗
# %%
import pandas as pd
# %%
df = pd.read_csv('data/nykaa_campaign_data.csv')
print(f"原始数据量: {len(df)} 行, {len(df.columns)} 列")
print(f"列名: {list(df.columns)}")
cleaning_log = []
# %%
# 缺失值检测
missing = df.isnull().sum()
missing_pct = (missing / len(df) * 100).round(2)
missing_report = pd.DataFrame({
    '缺失数量': missing,
    '缺失比例(%)': missing_pct
})
print(f"\n--- 缺失值检测 ---")
print(missing_report[missing_report['缺失数量'] > 0] if missing.sum() > 0 else "无缺失值")
cleaning_log.append(f"缺失值检测: 共 {missing.sum()} 个缺失值")
# %%
# 重复值检测
dup_count = df.duplicated().sum()
print(f"\n--- 重复值检测 ---")
print(f"重复行数: {dup_count}")
cleaning_log.append(f"重复值检测: {dup_count} 条重复行")
if dup_count > 0:
    df = df.drop_duplicates().reset_index(drop=True)

# %%
# 异常值检测 — 数值列不应为负
numeric_cols = ['Impressions', 'Clicks', 'Leads', 'Conversions', 'Revenue',
                'Acquisition_Cost', 'ROI', 'Engagement_Score', 'Duration']
neg_counts = {}
for col in numeric_cols:
    if col in df.columns:
        neg = (df[col] < 0).sum()
        if neg > 0 and col not in ['ROI']:
            neg_counts[col] = neg

print(f"\n--- 负值检测 ---")
for col, cnt in neg_counts.items():
    print(f"  {col}: {cnt} 个负值")
cleaning_log.append(f"负值检测: {'; '.join([f'{k}={v}' for k,v in neg_counts.items()]) if neg_counts else '无非预期负值(ROI允许为负)'}")
# %%
# 逻辑一致性检测
# Clicks <= Impressions, Leads <= Clicks, Conversions <= Leads
logic_issues = {}
logic_issues['Clicks>Impressions'] = (df['Clicks'] > df['Impressions']).sum()
logic_issues['Leads>Clicks'] = (df['Leads'] > df['Clicks']).sum()
logic_issues['Conversions>Leads'] = (df['Conversions'] > df['Leads']).sum()

print(f"\n--- 逻辑一致性检测 ---")
for k, v in logic_issues.items():
    print(f"  {k}: {v} 条")
cleaning_log.append(f"逻辑一致性: {'; '.join([f'{k}={v}' for k,v in logic_issues.items()])}")

# %%
# 唯一性检测
print(f"\n--- Campaign_ID唯一性 ---")
dup_ids = df['Campaign_ID'].duplicated().sum()
print(f"  重复Campaign_ID: {dup_ids} 条")
cleaning_log.append(f"Campaign_ID重复: {dup_ids} 条")
# %%
# 日期格式标准化
df['Date'] = pd.to_datetime(df['Date'], errors='coerce')
invalid_dates = df['Date'].isnull().sum()
print(f"\n--- 日期格式 ---")
print(f"  无效日期: {invalid_dates} 条")
cleaning_log.append(f"无效日期: {invalid_dates} 条")

# %%
# 分类变量标准化
print(f"\n--- 分类变量分布 ---")
for col in ['Campaign_Type', 'Target_Audience', 'Language', 'Customer_Segment']:
    print(f"  {col}: {df[col].nunique()} 类 — {list(df[col].unique())}")
# %%
# Channel_Used 拆分 (多值字段)
df['Channel_List'] = df['Channel_Used'].str.split(', ')
all_channels = set()
for ch_list in df['Channel_List']:
    if isinstance(ch_list, list):
        all_channels.update(ch_list)
print(f"\n--- 渠道拆分 ---")
print(f"  独立渠道: {sorted(all_channels)}")
# %%
# 衍生指标计算
df['CTR'] = (df['Clicks'] / df['Impressions'] * 100).round(4)          # 点击率
df['Click_to_Lead_Rate'] = (df['Leads'] / df['Clicks'] * 100).round(4)  # 线索转化率
df['Lead_to_Conv_Rate'] = (df['Conversions'] / df['Leads'] * 100).round(4)  # 成交转化率
df['Overall_Conv_Rate'] = (df['Conversions'] / df['Impressions'] * 100).round(4)  # 总转化率
df['CPC'] = (df['Acquisition_Cost'] / df['Clicks']).round(4)            # 每次点击成本
df['CPA'] = (df['Acquisition_Cost'] / df['Conversions']).round(4)       # 每次获客成本
df['Revenue_per_Conv'] = (df['Revenue'] / df['Conversions']).round(4)   # 单笔成交收入
df['Profit'] = (df['Revenue'] - df['Acquisition_Cost']).round(2)        # 净利润
df['Year_Month'] = df['Date'].dt.to_period('M').astype(str)

print(f"\n--- 衍生指标 ---")
print(f"  新增指标: CTR, Click_to_Lead_Rate, Lead_to_Conv_Rate, Overall_Conv_Rate, CPC, CPA, Revenue_per_Conv, Profit, Year_Month")

cleaning_log.append(f"衍生指标: 新增9个计算字段(CTR/CPC/CPA等)")
cleaning_log.append(f"最终清洗后数据量: {len(df)} 行, {len(df.columns)} 列")

print(f"\n清洗后数据量: {len(df)} 行")
# %%
# 导出清洗完成的数据集
output_path = "data/nykaa_campaign_cleaned.csv"
df.to_csv(output_path, index=False, encoding="utf-8-sig")
print(f"导出文件行数：{len(df)}，字段总数：{len(df.columns)}")
# 导出数据清洗日志（文本文件，留存完整清洗记录）
log_path = "data/data_cleaning_log.txt"
with open(log_path, "w", encoding="utf-8") as f:
    f.write("===== Nykaa 数据清洗日志 =====\n")
    for line in cleaning_log:
        f.write("- " + line + "\n")