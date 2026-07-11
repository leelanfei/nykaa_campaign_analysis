-- Nykaa_营销活动分析
-- 整体漏斗(m1)
SELECT
    SUM(Impressions) as 曝光数,
    SUM(Clicks) as 点击数,
    SUM(Leads) as 线索数,
    SUM(Conversions) as 成交数,
    ROUND(SUM(Clicks) * 100.0 / SUM(Impressions), 2) as 曝光到点击转化率,
    ROUND(SUM(Leads) * 100.0 / SUM(Clicks), 2) as 点击到线索转化率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Leads), 2) as 线索到成交转化率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Impressions), 2) as 总转化率,
    ROUND(SUM(Revenue), 0) as 总收入,
    ROUND(SUM(Acquisition_Cost), 0) as 总获客成本,
    ROUND(AVG(ROI), 4) as 平均ROI
FROM nykaa_campaign_cleaned;

-- 按Campaign_Type漏斗(m2_活动类型)
SELECT
    Campaign_Type as 活动类型,
    COUNT(*) as 活动数,
    SUM(Impressions) as 曝光数,
    SUM(Clicks) as 点击数,
    SUM(Leads) as 线索数,
    SUM(Conversions) as 成交数,
    ROUND(SUM(Clicks) * 100.0 / SUM(Impressions), 2) as 点击率CTR,
    ROUND(SUM(Leads) * 100.0 / SUM(Clicks), 2) as 线索率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Leads), 2) as 成交率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Impressions), 2) as 总转化率,
    ROUND(SUM(Revenue), 0) as 总收入,
    ROUND(SUM(Acquisition_Cost), 0) as 总成本,
    ROUND(AVG(ROI), 4) as 平均ROI
FROM nykaa_campaign_cleaned
GROUP BY Campaign_Type
ORDER BY SUM(Revenue) DESC;

-- 按Target_Audience漏斗(m3_目标受众)
SELECT
    Target_Audience as 目标受众,
    COUNT(*) as 活动数,
    SUM(Impressions) as 曝光数,
    SUM(Clicks) as 点击数,
    SUM(Leads) as 线索数,
    SUM(Conversions) as 成交数,
    ROUND(SUM(Clicks) * 100.0 / SUM(Impressions), 2) as 点击率CTR,
    ROUND(SUM(Leads) * 100.0 / SUM(Clicks), 2) as 线索率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Leads), 2) as 成交率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Impressions), 2) as 总转化率,
    ROUND(SUM(Revenue), 0) as 总收入,
    ROUND(SUM(Acquisition_Cost), 0) as 总成本,
    ROUND(AVG(ROI), 4) as 平均ROI
FROM nykaa_campaign_cleaned
GROUP BY Target_Audience
ORDER BY AVG(ROI) DESC;

-- 按Customer_Segment漏斗(m4_客户分群)
SELECT
    Customer_Segment as 客户分群,
    COUNT(*) as 活动数,
    SUM(Impressions) as 曝光数,
    SUM(Clicks) as 点击数,
    SUM(Leads) as 线索数,
    SUM(Conversions) as 成交数,
    ROUND(SUM(Clicks) * 100.0 / SUM(Impressions), 2) as 点击率CTR,
    ROUND(SUM(Leads) * 100.0 / SUM(Clicks), 2) as 线索率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Leads), 2) as 成交率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Impressions), 2) as 总转化率,
    ROUND(SUM(Revenue), 0) as 总收入,
    ROUND(SUM(Acquisition_Cost), 0) as 总成本,
    ROUND(AVG(ROI), 4) as 平均ROI
FROM nykaa_campaign_cleaned
GROUP BY Customer_Segment
ORDER BY AVG(ROI) DESC;

-- 按Language漏斗(m5_语言)
SELECT
    Language as 语言,
    COUNT(*) as 活动数,
    SUM(Impressions) as 曝光数,
    SUM(Clicks) as 点击数,
    SUM(Leads) as 线索数,
    SUM(Conversions) as 成交数,
    ROUND(SUM(Clicks) * 100.0 / SUM(Impressions), 2) as 点击率CTR,
    ROUND(SUM(Leads) * 100.0 / SUM(Clicks), 2) as 线索率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Leads), 2) as 成交率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Impressions), 2) as 总转化率,
    ROUND(SUM(Revenue), 0) as 总收入,
    ROUND(SUM(Acquisition_Cost), 0) as 总成本,
    ROUND(AVG(ROI), 4) as 平均ROI
FROM nykaa_campaign_cleaned
GROUP BY Language
ORDER BY AVG(ROI) DESC;

-- 按Duration分组漏斗(m6_活动周期)
SELECT
    CASE
        WHEN Duration <= 7 THEN '1-7天'
        WHEN Duration <= 14 THEN '8-14天'
        WHEN Duration <= 21 THEN '15-21天'
        WHEN Duration <= 30 THEN '22-30天'
        ELSE '30天以上'
    END as 活动周期,
    COUNT(*) as 活动数,
    SUM(Impressions) as 曝光数,
    SUM(Clicks) as 点击数,
    SUM(Leads) as 线索数,
    SUM(Conversions) as 成交数,
    ROUND(SUM(Clicks) * 100.0 / SUM(Impressions), 2) as 点击率CTR,
    ROUND(SUM(Leads) * 100.0 / SUM(Clicks), 2) as 线索率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Leads), 2) as 成交率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Impressions), 2) as 总转化率,
    ROUND(SUM(Revenue), 0) as 总收入,
    ROUND(SUM(Acquisition_Cost), 0) as 总成本,
    ROUND(AVG(ROI), 4) as 平均ROI
FROM nykaa_campaign_cleaned
GROUP BY 1
ORDER BY 1;

-- 渠道效果分析（拆分多渠道）
WITH RECURSIVE split_cte AS (
    SELECT
        Campaign_ID,
        Campaign_Type,
        TRIM(SUBSTRING_INDEX(Channel_Used, ', ', 1)) AS Channel,
        IF(LOCATE(', ', Channel_Used) > 0,
           SUBSTRING(Channel_Used, LOCATE(', ', Channel_Used) + 2),
           NULL) AS remaining,
        -- 计算该活动有多少个渠道（逗号+空格的个数 + 1）
        1 + (LENGTH(Channel_Used) - LENGTH(REPLACE(Channel_Used, ', ', ''))) / 2 AS channel_cnt,
        Impressions, Clicks, Leads, Conversions,
        Revenue, Acquisition_Cost, ROI, Engagement_Score
    FROM nykaa_campaign_cleaned
    UNION ALL
    SELECT
        Campaign_ID,
        Campaign_Type,
        TRIM(SUBSTRING_INDEX(remaining, ', ', 1)) AS Channel,
        IF(LOCATE(', ', remaining) > 0,
           SUBSTRING(remaining, LOCATE(', ', remaining) + 2),
           NULL) AS remaining,
        channel_cnt,
        Impressions, Clicks, Leads, Conversions,
        Revenue, Acquisition_Cost, ROI, Engagement_Score
    FROM split_cte
    WHERE remaining IS NOT NULL
)
-- 按Channel分组漏斗(m7_投放渠道)
SELECT
    Channel AS 渠道,
    COUNT(DISTINCT Campaign_ID) AS 涉及活动数,   -- 去重统计真实活动数
    SUM(Impressions / channel_cnt) AS 曝光数,
    SUM(Clicks / channel_cnt) AS 点击数,
    SUM(Leads / channel_cnt) AS 线索数,
    SUM(Conversions / channel_cnt) AS 成交数,
    ROUND(SUM(Clicks / channel_cnt) * 100.0 / NULLIF(SUM(Impressions / channel_cnt), 0), 2) AS 点击率CTR,
    ROUND(SUM(Leads / channel_cnt) * 100.0 / NULLIF(SUM(Clicks / channel_cnt), 0), 2) AS 线索率,
    ROUND(SUM(Conversions / channel_cnt) * 100.0 / NULLIF(SUM(Leads / channel_cnt), 0), 2) AS 成交率,
    ROUND(SUM(Conversions / channel_cnt) * 100.0 / NULLIF(SUM(Impressions / channel_cnt), 0), 2) AS 总转化率,
    ROUND(SUM(Revenue / channel_cnt), 0) AS 总收入,
    ROUND(SUM(Acquisition_Cost / channel_cnt), 0) AS 总成本,
    ROUND(AVG(ROI/ channel_cnt), 4) as 平均ROI
FROM split_cte
GROUP BY Channel
ORDER BY 平均ROI DESC;


-- 月度趋势
SELECT
    `Year_Month` as 月份,
    COUNT(*) as 活动数,
    SUM(Impressions) as 曝光数,
    SUM(Clicks) as 点击数,
    SUM(Leads) as 线索数,
    SUM(Conversions) as 成交数,
    ROUND(SUM(Clicks) * 100.0 / SUM(Impressions), 2) as 点击率,
    ROUND(SUM(Conversions) * 100.0 / SUM(Leads), 2) as 成交率,
    ROUND(AVG(ROI), 4) as 平均ROI,
    ROUND(SUM(Revenue), 0) as 总收入
FROM nykaa_campaign_cleaned
GROUP BY `Year_Month`
ORDER BY `Year_Month`;

-- ROI分布统计
SELECT
    CASE
        WHEN ROI < 0 THEN '亏损(ROI<0)'
        WHEN ROI < 1 THEN '低效(0-1)'
        WHEN ROI < 3 THEN '中等(1-3)'
        WHEN ROI < 5 THEN '良好(3-5)'
        ELSE '优秀(5+)'
    END as ROI等级,
    COUNT(*) as 活动数,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM nykaa_campaign_cleaned), 2) as 占比,
    ROUND(AVG(Revenue), 0) as 平均收入,
    ROUND(AVG(Acquisition_Cost), 0) as 平均成本
FROM nykaa_campaign_cleaned
GROUP BY 1
ORDER BY 1;

-- 总体KPI卡片
SELECT
    COUNT(*) AS 活动总数,
    ROUND(SUM(Impressions) / 1000000, 1) AS 总曝光_百万次,
    ROUND(SUM(Clicks) / 10000, 1) AS 总点击_万次,
    ROUND(SUM(Leads) / 10000, 1) AS 总线索_万条,
    ROUND(SUM(Conversions) / 10000, 1) AS 总成交_万单,
    ROUND(SUM(Clicks) * 100.0 / NULLIF(SUM(Impressions), 0), 2) AS 点击率_CTR,
    ROUND(SUM(Conversions) * 100.0 / NULLIF(SUM(Leads), 0), 2) AS 线索转化率,
    ROUND(SUM(Revenue) / 10000000, 2) AS 总收入_千万元,
    ROUND(SUM(Acquisition_Cost) / 10000, 2) AS 总成本_万元,
    ROUND(SUM(Revenue) / NULLIF(SUM(Acquisition_Cost), 0), 2) AS 整体ROI
FROM nykaa_campaign_cleaned;

-- 渠道和客户分群交叉
WITH RECURSIVE split_cte AS (
    SELECT
        Campaign_ID,
        Customer_Segment,                -- 人群维度
        TRIM(SUBSTRING_INDEX(Channel_Used, ', ', 1)) AS Channel,
        IF(LOCATE(', ', Channel_Used) > 0,
           SUBSTRING(Channel_Used, LOCATE(', ', Channel_Used) + 2),
           NULL) AS remaining,
        1 + (LENGTH(Channel_Used) - LENGTH(REPLACE(Channel_Used, ', ', ''))) / 2 AS channel_cnt,
        Impressions, Clicks, Leads, Conversions,
        Revenue, Acquisition_Cost, ROI
    FROM nykaa_campaign_cleaned

    UNION ALL

    SELECT
        Campaign_ID,
        Customer_Segment,
        TRIM(SUBSTRING_INDEX(remaining, ', ', 1)) AS Channel,
        IF(LOCATE(', ', remaining) > 0,
           SUBSTRING(remaining, LOCATE(', ', remaining) + 2),
           NULL) AS remaining,
        channel_cnt,
        Impressions, Clicks, Leads, Conversions,
        Revenue, Acquisition_Cost, ROI
    FROM split_cte
    WHERE remaining IS NOT NULL
)
SELECT
    Channel AS 渠道,
    Customer_Segment AS 客户分群,
    COUNT(DISTINCT Campaign_ID) AS 活动数,
    ROUND(SUM(Impressions / channel_cnt), 0) AS 曝光数,
    ROUND(SUM(Clicks / channel_cnt), 0) AS 点击数,
    ROUND(SUM(Leads / channel_cnt), 0) AS 线索数,
    ROUND(SUM(Conversions / channel_cnt), 0) AS 成交数,
    ROUND(SUM(Clicks / channel_cnt) * 100.0 / NULLIF(SUM(Impressions / channel_cnt), 0), 2) AS 点击率CTR,
    ROUND(SUM(Leads / channel_cnt) * 100.0 / NULLIF(SUM(Clicks / channel_cnt), 0), 2) AS 线索率,
    ROUND(SUM(Conversions / channel_cnt) * 100.0 / NULLIF(SUM(Leads / channel_cnt), 0), 2) AS 成交率,
    ROUND(SUM(Conversions / channel_cnt) * 100.0 / NULLIF(SUM(Impressions / channel_cnt), 0), 2) AS 总转化率,
    ROUND(SUM(Revenue / channel_cnt), 0) AS 总收入,
    ROUND(SUM(Acquisition_Cost / channel_cnt), 0) AS 总成本,
    ROUND(AVG(ROI/ channel_cnt), 4) as 平均ROI
FROM split_cte
GROUP BY Channel, Customer_Segment
ORDER BY Channel, 平均ROI DESC;