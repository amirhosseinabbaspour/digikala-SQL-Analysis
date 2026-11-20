-- ==========================================================
-- 1. Top 10 Cities by Total Sales & Order Count
-- ده شهر برتر ایران از نظر بیشترین مبلغ کل فروش و تعداد سفارش
-- ==========================================================
SELECT TOP 10
    city_name_fa AS City,
    COUNT(DISTINCT ID_Order) AS Total_Orders,
    SUM(Amount_Gross_Order) AS Total_Sales
FROM orders
WHERE city_name_fa IS NOT NULL
GROUP BY city_name_fa
ORDER BY Total_Sales DESC;

-- ==========================================================
-- 2. Monthly & Yearly Sales Trend
-- روند فروش و تعداد سفارش‌ها به تفکیک سال و ماه
-- ==========================================================
SELECT 
    YEAR(DateTime_CartFinalize) AS Order_Year,
    MONTH(DateTime_CartFinalize) AS Order_Month,
    COUNT(DISTINCT ID_Order) AS Total_Orders,
    SUM(Amount_Gross_Order) AS Total_Sales
FROM orders
WHERE DateTime_CartFinalize IS NOT NULL
GROUP BY YEAR(DateTime_CartFinalize), MONTH(DateTime_CartFinalize)
ORDER BY Order_Year, Order_Month;

-- ==========================================================
-- 3. Loyal / VIP Customers (More than 5 Orders)
-- مشتریان وفادار با بیش از ۵ سفارش و مجموع مبلغ خرید آن‌ها
-- ==========================================================
SELECT 
    ID_Customer,
    COUNT(DISTINCT ID_Order) AS Total_Orders,
    SUM(Amount_Gross_Order) AS Total_Spent
FROM orders
GROUP BY ID_Customer
HAVING COUNT(DISTINCT ID_Order) > 5
ORDER BY Total_Orders DESC, Total_Spent DESC;

-- ==========================================================
-- 4. Top 5 Best-Selling Items
-- ۵ کالای پرفروش بر اساس تعداد فروش و میانگین مبلغ سفارش
-- ==========================================================
SELECT TOP 5
    ID_Item,
    SUM(Quantity_item) AS Total_Quantity_Sold,
    ROUND(AVG(Amount_Gross_Order), 2) AS Avg_Order_Amount
FROM orders
GROUP BY ID_Item
ORDER BY Total_Quantity_Sold DESC;

-- ==========================================================
-- 5. Order Value Segmentation (CASE WHEN)
-- دسته‌بندی ارزش سبد خرید به سه سطح کم‌ارزش، متوسط و گران‌قیمت
-- ==========================================================
SELECT 
    CASE 
        WHEN Amount_Gross_Order < 500000 THEN 'Low Value (< 500K)'
        WHEN Amount_Gross_Order BETWEEN 500000 AND 2000000 THEN 'Medium Value (500K - 2M)'
        ELSE 'High Value (> 2M)'
    END AS Order_Segment,
    COUNT(ID_Order) AS Order_Count,
    SUM(Amount_Gross_Order) AS Total_Revenue
FROM orders
WHERE Amount_Gross_Order IS NOT NULL
GROUP BY 
    CASE 
        WHEN Amount_Gross_Order < 500000 THEN 'Low Value (< 500K)'
        WHEN Amount_Gross_Order BETWEEN 500000 AND 2000000 THEN 'Medium Value (500K - 2M)'
        ELSE 'High Value (> 2M)'
    END
ORDER BY Total_Revenue DESC;
