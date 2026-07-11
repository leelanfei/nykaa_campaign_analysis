import pandas as pd
import numpy as np
import ast
import os
import shutil

df = pd.read_csv('data/nykaa_campaign_cleaned.csv')
df['Date'] = pd.to_datetime(df['Date'], errors='coerce')
df['Channel_List'] = df['Channel_List'].apply(lambda x: ast.literal_eval(x) if isinstance(x, str) else x)

output_dir = 'output/tableau'
os.makedirs(output_dir, exist_ok=True)

df_main = df.copy()
df_main['Channel_List_Str'] = df_main['Channel_List'].apply(lambda x: ', '.join(x))
df_main = df_main.drop(columns=['Channel_List'])
print(f'[master] {len(df_main)} rows, {len(df_main.columns)} cols')

cols_ch = ['Campaign_ID','Campaign_Type','Target_Audience','Duration','Channel_Used',
    'Language','Engagement_Score','Customer_Segment','Date','Impressions','Clicks',
    'Leads','Conversions','Revenue','Acquisition_Cost','ROI','CTR','Click_to_Lead_Rate',
    'Lead_to_Conv_Rate','Overall_Conv_Rate','CPC','CPA','Revenue_per_Conv','Profit',
    'Year_Month','Channel_List']
df_ch = df[cols_ch].copy()
df_ch = df_ch.explode('Channel_List')
df_ch.rename(columns={'Channel_List': 'Channel'}, inplace=True)
df_ch['channel_count'] = df_ch.groupby('Campaign_ID')['Channel'].transform('count')
for col in ['Impressions','Clicks','Leads','Conversions','Revenue','Acquisition_Cost','Profit']:
    df_ch[col] = (df_ch[col] / df_ch['channel_count']).round(2)
df_ch['ROI_channel'] = (df_ch['Revenue'] / df_ch['Acquisition_Cost']).round(4)
df_ch['ROI_channel'] = df_ch['ROI_channel'].replace([np.inf, -np.inf], np.nan)
df_ch['CTR_ch'] = (df_ch['Clicks'] / df_ch['Impressions'] * 100).round(4)
df_ch['Lead_Rate_ch'] = (df_ch['Leads'] / df_ch['Clicks'] * 100).round(4)
df_ch['Conv_Rate_ch'] = (df_ch['Conversions'] / df_ch['Leads'] * 100).round(4)
df_ch['ROI_campaign'] = df_ch['Campaign_ID'].map(df.set_index('Campaign_ID')['ROI'])
df_ch = df_ch.drop(columns=['channel_count'])
print(f'[channel] {len(df_ch)} rows, {len(df_ch.columns)} cols')

monthly = df.groupby('Year_Month').agg(
    campaigns=('Campaign_ID','count'), impressions=('Impressions','sum'),
    clicks=('Clicks','sum'), leads=('Leads','sum'), conversions=('Conversions','sum'),
    revenue=('Revenue','sum'), cost=('Acquisition_Cost','sum'), avg_roi=('ROI','mean')
).reset_index()
monthly['CTR'] = (monthly['clicks'] / monthly['impressions'] * 100).round(2)
monthly['conv_rate'] = (monthly['conversions'] / monthly['leads'] * 100).round(2)
monthly['overall_roi'] = (monthly['revenue'] / monthly['cost']).round(4)
print(f'[monthly] {len(monthly)} rows')

bins = [-np.inf, 0, 1, 3, 5, np.inf]
labels = ['Loss(<0)','Low(0-1)','Mid(1-3)','Good(3-5)','Great(5+)']
df_roi = df[['ROI','Revenue','Acquisition_Cost']].copy()
df_roi['ROI_Level'] = pd.cut(df_roi['ROI'], bins=bins, labels=labels)
roi_s = df_roi.groupby('ROI_Level', observed=False).agg(
    campaigns=('ROI','count'), pct=('ROI',lambda x: round(len(x)/len(df_roi)*100,2)),
    avg_rev=('Revenue','mean'), avg_cost=('Acquisition_Cost','mean')
).reset_index()

df_main.to_csv(f'{output_dir}/t1_campaign_master.csv', index=False, encoding='utf-8-sig')
df_ch.to_csv(f'{output_dir}/t2_channel_exploded.csv', index=False, encoding='utf-8-sig')
monthly.to_csv(f'{output_dir}/t3_monthly_trend.csv', index=False, encoding='utf-8-sig')
roi_s.to_csv(f'{output_dir}/t4_roi_segments.csv', index=False, encoding='utf-8-sig')

sql_dir = 'output/data_sql'
for f in os.listdir(sql_dir):
    if f.endswith('.csv'):
        shutil.copy(os.path.join(sql_dir, f), os.path.join(output_dir, f))

print('All datasets exported to output/tableau/')