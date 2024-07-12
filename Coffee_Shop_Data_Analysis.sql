Select * From coffee_shop_data;

# Find Total Sales Analysis

Select Concat((ROUND(Sum(Unit_price*transaction_qty),0))/1000,"K") as Total_Sales
From coffee_shop_data
Where 
	Month(transaction_date)= 3; -- March Month = 3 [If you want to find for March month]
    
# Month On Month Increase or Decrese in sales

Select 
	Month(transaction_date) as Require_Month, 
    ROUND(Sum(Unit_price*transaction_qty),0) As Total_Sales, 
    (Sum(Unit_price*transaction_qty) - Lag(Sum(Unit_price*transaction_qty),1) Over (Order By Month(transaction_date))) / Lag(Sum(Unit_price*transaction_qty),1) Over (Order By Month(transaction_date)) * 100 As M_O_M_Increase
From coffee_shop_data
Where Month(transaction_date) IN ( 4,5) -- Month April and May
Group By Month(transaction_date)
Order By Month(transaction_date);

# Total Number of Order Analysis

Select Count(transaction_ids) As Total_Orders
From coffee_shop_data
Where 
	Month(transaction_date)= 3;
    
# Month On Month Increase or Decrese in Orders
Select 
Month(transaction_date) As Require_Month,
Round(Count(transaction_ids),1) As Total_Orders,
lag(count(transaction_ids),1,0)over(order by month(transaction_date)) as Previous_Month_Data,
(Count(transaction_ids)-lag(count(transaction_ids),1,0)over(order by month(transaction_date))) As Order_Difference_Comp_Prev_Month,
(Count(transaction_ids)-lag(count(transaction_ids),1,0)over(order by month(transaction_date)))/
lag(count(transaction_ids),1,0)over(order by month(transaction_date))*100 as Percentage

From coffee_shop_data
-- Where Month(transaction_date) IN ( 4,5) -- Month April and May
Group By Month(transaction_date)
Order By Month(transaction_date);

# Total Quantity Sold

Select sum(transaction_qty) As Total_Quantity_Sold
From coffee_shop_data
Where month(transaction_date) = 6;

# Month On Month Increase or Decrese in Quantity

Select 
month(transaction_date) As Required_Month,
sum(transaction_qty) As Total_Quantity_Sold,
Lag(sum(transaction_qty),1,0)over(order by month(transaction_date)) as Previous_Month_Date,
sum(transaction_qty)-Lag(sum(transaction_qty),1)over(order by month(transaction_date)) As Diff_In_QTY,
(sum(transaction_qty)-Lag(sum(transaction_qty),1)over(order by month(transaction_date)))/Lag(sum(transaction_qty),1)over(order by month(transaction_date))*100 As Percentage
From coffee_shop_data
Group By month(Transaction_date)
Order By Month(transaction_date);

# Sales Analysis by WeekDays and WeekEnds
# Segment Sales data into Weekday and Weekend to analyze Performance variation
# Sunday = 1, Mon = 2 ... ..Saturday = 7 [WeekNumber In SQL]

Select 
	Case when dayofweek(transaction_date) IN (1,7) then 'weekend' else 'weekdays' end as Datetype,      -- Used DAYOFWEEK
   concat(round(Sum(Unit_price*transaction_qty)/1000,1),'K') As total_Sales                             -- Total sales of weekdays and Weekends comparision
From coffee_shop_data
Where month(transaction_date) = 2
group by Case when dayofweek(transaction_date) IN (1,7) then 'weekend' else 'weekdays' end;

# Sales Analysis By Store Location

Select Store_location, Concat(Round(Sum(Unit_price*transaction_qty)/1000,2),'K') As Total_Sales
From coffee_shop_data
Where month(transaction_date) = 5  -- May Month 
group by store_location
Order By Concat(Round(Sum(Unit_price*transaction_qty)/1000,2),'K') DESC;

# Daily Sales Analysis With Average Line
# Step 1 - Find the Average sales Line
# Step 2 - Find Daily Sales
# Step 3 - Find the Sales i.e Above the Avg line and Below the Avg Line

-- Average sales Line

SELECT 
    AVG(total_sales) AS AVG_Sales
FROM
    (SELECT 
        SUM(Unit_price * transaction_qty) AS total_sales
    FROM
        coffee_shop_data
    WHERE
        MONTH(transaction_date) = 5
    GROUP BY transaction_date ) AS Subquery_Query;
    
-- Daily Day wise Sales
    
Select day(transaction_date) As Day_Of_Month, concat(round(Sum(transaction_qty*unit_price)/1000,2),'K') As Total_Day_Sales
from coffee_shop_data
Where month(transaction_date) = 5
group by day(transaction_date)
Order by day(transaction_date);

-- Map the Daily sales with Average Sales Line [ above average or Below ] 

Select Day_Of_Month, total_sales, avg_sales,
Case 
when total_sales > avg_sales then 'Above The Average'
when total_sales < avg_sales then 'Below The Average'
Else 'Equal To Average'
End as Sales_Status

From ( Select
		DAY(transaction_date) as Day_Of_Month,
        sum(Transaction_qty * Unit_Price) As total_sales,
        AVG(sum(Transaction_qty * Unit_Price)) over() AS avg_sales
        
        From coffee_shop_data
        where month(transaction_date) = 5
        Group by day(transaction_date)
        ) AS Sales_Data
        Order By Day_Of_Month;
        
# Find Sales by Product Category, Top 10

Select product_category, sum(Transaction_qty * Unit_Price) As total_sales
from coffee_shop_data
group by product_category
order by sum(Transaction_qty * Unit_Price) DESC
Limit 10;

# Sales By Hours, Find sales

Select
Hour(transaction_time),
SUM(transaction_qty*unit_price) AS Total_sales

From coffee_shop_data
Where Month(transaction_date) = 5
Group By Hour(transaction_time)
-- Order by SUM(transaction_qty*unit_price) Desc
order by Hour(transaction_time);

# Sales by Days [ Monday,Tuesday etc.] TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY

SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_data
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;


# Sales Analysis By Days and Hours

Select 
sum(Transaction_qty * Unit_Price) As Total_Sales,
sum(Transaction_qty) As Total_Qty,
count(transaction_ids) AS Total_Orders
From coffee_shop_data
Where month(Transaction_date)=5 -- May Month
And dayofweek(transaction_Date) = 2  -- Monday
And hour(transaction_time) = 14;  -- Hour Number