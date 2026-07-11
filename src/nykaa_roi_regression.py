# Nykaa 营销渠道 ROI 驱动因素多元回归分析
# 因变量：ROI
# 核心自变量：Campaign_Type（活动类型） Duration（活动周期）
# 控制变量：
# 连续变量：Engagement_Score（互动得分），Acquisition_Cost（获取成本的对数）
# 分类哑变量：Language, Target_Audience, Customer_Segment（均以首类为基准，避免多重共线性）

import pandas as pd
import numpy as np
import statsmodels.api as sm


# 载入数据
df = pd.read_csv('data/nykaa_campaign_cleaned.csv')
df['Date'] = pd.to_datetime(df['Date'], errors='coerce')

# 因变量 Y
Y = df['ROI'].astype(float)

# 核心自变量
# 活动类型: Campaign_Type (Social Media / Paid Ads / Influencer / Email / SEO)
ct_dummies = pd.get_dummies(df['Campaign_Type'], prefix='CT', drop_first=True).astype(float)
# 连续变量
X_numeric = df[['Duration', 'Engagement_Score', 'Acquisition_Cost']].astype(float)
# 分类哑变量
lang_dummies = pd.get_dummies(df['Language'], drop_first=True).astype(float)
aud_dummies = pd.get_dummies(df['Target_Audience'], drop_first=True).astype(float)
seg_dummies = pd.get_dummies(df['Customer_Segment'], drop_first=True).astype(float)
# 合并所有自变量
X = pd.concat([X_numeric, ct_dummies, lang_dummies, aud_dummies, seg_dummies], axis=1)
# 合并所有自变量
X = pd.concat([X_numeric, ct_dummies, lang_dummies, aud_dummies], axis=1)
# 添加截距项
X = sm.add_constant(X)

# 清除缺失值与无穷值
mask = ~(X.isnull().any(axis=1) | Y.isnull())
X = X[mask]
Y = Y[mask]
print(f"回归样本量: {len(Y)}")
print(f"自变量数量: {X.shape[1]} (含截距)")

# OLS 回归
model = sm.OLS(Y, X).fit()
print(model.summary())

# 回归结果系数表整理
reg_results = pd.DataFrame({
    'variable': model.params.index,
    'coef': model.params.values.round(6),
    'std_err': model.bse.values.round(6),
    't': model.tvalues.values.round(4),
    'p_value': model.pvalues.values.round(6),
    'ci_lower': model.conf_int().iloc[:, 0],
    'ci_upper': model.conf_int().iloc[:, 1],
    '显著性': ['***' if p < 0.01 else '**' if p < 0.05 else '*' if p < 0.1 else ''
              for p in model.pvalues.values]
})
print(reg_results.to_string(index=False))
# 整体统计量
model_stats = pd.Series({
    'R-squared': model.rsquared,
    'Adj. R-squared': model.rsquared_adj,
    'F-statistic': model.fvalue,
    'Prob (F-statistic)': model.f_pvalue,
    '样本量': int(model.nobs),
})
print(model_stats)

# 保存系数表
reg_results.to_csv('data/regression_coefficients.csv')
# 保存整体统计量
model_stats.to_csv('data/model_stats.csv', header=False)
model_stats.to_csv('data/model_stats.csv', header=False)