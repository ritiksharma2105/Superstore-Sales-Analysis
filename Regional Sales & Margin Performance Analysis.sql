#SuperStore_Sales_Dataset

/* OverView

With growing demands and cut-throat competitions in the market, 
a Superstore Giant is seeking your knowledge in understanding what works best for them. 
They would like to understand which products, regions, categories and customer segments they should target or avoid.
*/

/* Data Dictionary

Row ID => Unique ID for each row.
Order ID => Unique Order ID for each Customer.
Order Date => Order Date of the product.
Ship Date => Shipping Date of the Product.
Ship Mode=> Shipping Mode specified by the Customer.
Customer ID => Unique ID to identify each Customer.
Customer Name => Name of the Customer.
Segment => The segment where the Customer belongs.
Country => Country of residence of the Customer.
City => City of residence of of the Customer.
State => State of residence of the Customer.
Postal Code => Postal Code of every Customer.
Region => Region where the Customer belong.
Product ID => Unique ID of the Product.
Category => Category of the product ordered.
Sub-Category => Sub-Category of the product ordered.
Product Name => Name of the Product
Sales => Sales of the Product.
Quantity => Quantity of the Product.
Discount => Discount provided.
Profit => Profit/Loss incurred.

*/

/*
Top 3 Selling Products in Superstore
Avg profit margin for each category
Which sub-category of products has the highest demand?
Top 10 most profitable states
Customr wise top sales
*/

Create database Superstore; -- CREATED DATABASE to import table, without this it can't be done

use superstore; -- Activating the schema for analysis --

Alter Table `sample - superstore`
Rename to SUPERSTORE_DATA; -- renamed the table name --

select * from SUPERSTORE_DATA; -- viewing a table -- 

desc table SUPERSTORE_DATA; -- viewing a table details by describing it --

/*
Select * from superstore_data    ----------------- No Values in the dataset --------
where column_name is null
*/

#-------------------------------------------------------------------------------------#

#Step1- Renaming Columns

Alter Table SUPERSTORE_DATA
change column `Row ID` row_id int,
change column `Order ID` order_id text,
change column `Order Date` order_date text,
change column `Ship Date` ship_date text,
change column `Ship Mode` ship_mode text,
change column `Customer ID` customer_id text,
change column `Customer Name` customer_name text,
change column `Postal Code` postal_code int, 
change column `Product ID` product_id text,
change column `Sub-Category` sub_category text,
change column `Product Name` product_name text;

#------------------------------- Step-1 Completed----------------------------------------#

#Step-2  Conversion of dataType of required columns

Alter table superstore_data
modify column row_id int primary key not null,
modify column order_id varchar(50);

#---------------------------------------------------------------------------------------------#

#Step-3 Modifying Date Columns Datatype i.e., (order_date & ship_date)

select 
	order_date,
	ship_date
from superstore_data;  -- retrieving the both date columns --

select 
    order_date
from superstore_data
where order_date like '%/%';  -- retrieving the order_date column for review--

select 
	order_date,
		date_format(str_to_date(replace(order_date, '/', '-'), '%m-%d-%Y'), '%m-%d-%Y') as U_order_date
from superstore_data
where order_date like '%/%'; -- running cmd for changing date format from '/' to '-' --

select 
    ship_date,
	      date_format(str_to_date(replace(ship_date, '/', '-'), '%m-%d-%Y'), '%m-%d-%Y') as U_ship_date
from superstore_data
where ship_date like '%/%';  -- running cmd for changing date format from '/' to '-' --

CREATE TABLE U_Superstore_data as
Select * from superstore_data; -- created duplicated table from existing table --

Update U_Superstore_data 
set order_date = date_format(str_to_date(replace(order_date, '/', '-'), '%m-%d-%Y'), '%m-%d-%Y')
where order_date like '%/%'; -- updated the new date format for ORDER_DATE in new duplicate table --

Update U_Superstore_data 
Set ship_date = date_format(str_to_date(replace(ship_date, '/', '-'), '%m-%d-%Y'), '%m-%d-%Y')
where ship_date like '%/%'; -- updated the new date format for SHIP_DATE in new duplicate table ----

Select 
    order_date,
    ship_date
from U_Superstore_data; -- Both the date columns updated in the new valid format ----

Select * from superstore_data; -- checking old table with wrong Date Format -----

Select * from U_Superstore_data; -- Checking New table with Valid Format ------

Drop table superstore_data; -- Old table Dropped --

Alter Table u_superstore_data
Rename to Superstore_data; -- Renamed the table name --

Select * from superstore_Data;

#----------------------------------------------------------------------------------#

#Step-4 Checking, if there is any duplicate values present in Dataset

Select row_id,
count(*) from superstore_data
group by row_id
having count(*) > 1; 

Select order_id, 
count(*) from superstore_data
group by order_id
having count(*) > 1;

Select customer_id, 
count(*) from superstore_data
group by customer_id
having count(*) > 1;

Select product_id, 
count(*) from superstore_data
group by product_id
having count(*) > 1;

#-------------------------------------------------------------------------------#

#Step-5 Column creation for Month and Year for Analysis

Select * from superstore_data;

Alter Table superstore_data                    -- Added column for Month-Year extraction --
add column Order_Month Varchar(30),
add column Order_Month_Year Varchar(30),
add column Order_Date_Updated date;

Select 
     order_date,
     monthname(str_to_date(order_date, '%m-%d-%Y')) as Order_Month,
     date_format(str_to_date(order_date, '%m-%d-%Y'), '%M-%Y') as Order_Month_Year,
     date(date_format(str_to_date(order_date, '%m-%d-%Y'), '%Y-%m-%d')) as Order_Date_Updated
from superstore_data;

Update superstore_data
set Order_Month = monthname(str_to_date(order_date, '%m-%d-%Y')),
Order_Month_Year = date_format(str_to_date(order_date, '%m-%d-%Y'), '%M-%Y'),
Order_Date_Updated = date(date_format(str_to_date(order_date, '%m-%d-%Y'), '%Y-%m-%d'));

Select * from superstore_data;

Alter Table superstore_data
Modify Order_date_updated date after order_date; -- placed updated date column after old one --

Alter table superstore_data
drop column order_date; -- dropped wrong date format column --

Alter Table superstore_data
Modify Order_Month varchar(30) after order_date_updated,
Modify Order_Month_Year varchar(30) after Order_Month;    -- placed updated Month/Year column after old one --

Select * from superstore_data;

Select 
   ship_date,
   date_format(str_to_date(ship_date, '%m-%d-%Y'), '%Y-%m-%d') as Ship_date_updated
from superstore_data;

Alter Table Superstore_data
Add column Ship_Date_Updated Date
After Ship_date;

Update superstore_data
set Ship_date_Updated = date_format(str_to_date(ship_date, '%m-%d-%Y'), '%Y-%m-%d');

Select * from superstore_data;

Alter Table Superstore_data
drop column Ship_date;

Select Order_date_updated,
	quarter(Order_date_updated) as Quarter
from superstore_data;

Alter Table superstore_data
Add column Quarter int
After Ship_Date_Updated; -- Added Quarter column in the dataset --

Update Superstore_data
Set Quarter = quarter(Order_date_updated);  -- Updated Quarter Column for further Analysis --

Select * from superstore_data;

#----------------------------------------------------------------------------------------------#

#Step-6-> Exploratory Data Analysis
Select * from superstore_data;

#1--> Calculating total orders based on ship_mode

Select ship_mode,
    count(*) as Order_Count
from superstore_data
group by ship_mode
order by Order_count desc;

#2--> Calculating total sales based on total order count & segment

Select Segment, 
	Count(*) as Total_Orders,
	round(sum(sales),2) as Total_Sales
from superstore_data
group by segment
order by Total_Sales Desc;

#3--> Calculating Total Orders, Sales, Average Quantity Sold & Profit based on Region, Order by sales from largest to smallest.

select Region,
    Count(*) as Total_Orders,
	round(sum(sales),2) as Total_Sales,
    round(avg(Quantity),2) as Avg_Qty_Sold,
    round(sum(Profit),2) as Total_Profit
from superstore_data
group by Region
Order By Total_Sales Desc; -- Comparing West region with other regions, found that West region is having the highest profit including sales

#4--> Calculating Total Orders, Sales, Average Quantity Sold & Profit based on Region & Category, Order by sales from largest to smallest.

select Region, Category,
    Count(*) as Total_Orders,
	round(sum(sales),2) as Total_Sales,
    round(avg(Quantity),2) as Avg_Qty_Sold,
    round(sum(Profit),2) as Total_Profit
from superstore_data
group by Region, Category
Order By Total_Sales Desc; -- Technology category has the highest sales along with the Highest Profit in Segment.

#5--> Calculating Total Orders, Sales, Average Quantity Sold & Profit based on Category & Sub-Category, Order by sales from largest to smallest.

select Category, Sub_Category,
    Count(*) as Total_Orders,
	round(sum(sales),2) as Total_Sales,
    round(avg(Quantity),2) as Avg_Qty_Sold,
    round(sum(Profit),2) as Total_Profit
from superstore_data
group by Category, Sub_Category
Order By Total_Sales Desc; 

#6--> Calculating Quarter wise sales based on Total Profit

Select Quarter,
	round(sum(sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit
from superstore_data
Group by Quarter
Order By Total_sales Desc; -- 4th Quarter having the Highest Sale & profit --

#7--> Calculating Top 3 selling products & their sub-category in superstore

Select Category, Sub_Category, Product_name,
     Round(sum(Sales),2) as Total_sales
from superstore_data
Group by Category, Sub_Category, Product_name
Order By Total_Sales DESC
Limit 3;
   
 #8--> Calculating Average Profit Margin for each category
 
 Select Category,
     Round(Avg(Profit),2) as Average_Profit
from superstore_Data
group by Category
Order By Average_Profit Desc;
 
#9--> Calculating Top 10 most profitable states by Giving them a Unique row number.

Select State,
    round(Sum(Profit),2) as Total_Profit,
    row_number() over (order by Sum(Profit) Desc) as Rn
from superstore_data
Group by State
Limit 10;                         -- by using the Row Number in WF, each row is assigned by unique value of number --

#10--> Customer wise top sales

Select 
      State, customer_name,
	round(sum(sales),2) as Total_Sales
from superstore_data
group  by State, customer_name
Order By Total_Sales desc
Limit 10;

#----------------------------------------------------------------------------------------------------------------#

#11--> CTE (Common Table Expression) 

#11.1----------------->> Calculate the Year Wise Sales using Common Table Expression and sort it in smallest to largest on year basis 
#-- and calculate the Quantity & Sales Change comparing the previous year

With Qty_Change As (
Select
	Year(Order_date_updated) as Years,
    Round(Sum(Quantity),2) as Total_Quantity,
    Round(Sum(Sales),2) as Total_Sales
From Superstore_data
Group by Year(Order_date_updated)
)
Select 
	Years,
    Total_Sales,
	Total_Quantity,
	Total_Quantity - lag(Total_Quantity)
    over (order by Years) as Quantity_Change,
    Round (
    Total_Sales - lag(Total_Sales)
    over (Order by years)
    , 2) as Sales_Change
From Qty_change
order by Years;

 #11.2------------------>> Calculate the Quantity Sold & yearly sales with % change by comparing previous sales.

With Yearly_Percent_Change as (
Select
	Year(Order_date_updated) as Years,
    round(sum(Quantity),2) as Total_Quantity,
    round(sum(Sales),2) as Total_Sales
From superstore_data
Group by Years
)
Select
	Years,
    Total_Quantity,
    Total_Sales,
    Round(
		(Total_Quantity - lag(Total_Quantity) over (Order By years)) /
        lag(Total_Quantity) over (Order By Years) * 100
        , 2) as Quantity_Percent_Change,
        
	Round(
		(Total_Sales - lag(Total_sales) over (Order By years)) /
        lag(Total_Sales) over (Order by Years) * 100
        , 2) as Sales_Percent_Change
From Yearly_Percent_Change
Order By Years;

 #------------------------------------------------------------------------------------#
 
 #12-->> Calculating using window functions, the total monthly sales by year and month without merging the dataset using GROUP BY.

Select 
     Distinct Order_Month_Year,
     round(sum(sales) over (partition by Year(Order_Month_Year), Month(Order_Month_Year) order by Order_Month_Year Asc), 2)
     as Total_Sales
From Superstore_data; 

#-------------------------------------------------------------------------------------#

#13--->> Calculate Top 3 Subcategories over the years, and create the view.

Create View Top_Performing_Sub_Categories_By_Years As
With Top_Subcategory as (
Select
    Sub_Category,
    Year(Order_date_updated) as Years,
    round(sum(Sales),2) as Total_Sales,
    Rank () Over (partition by Year(Order_date_updated) order by sum(Sales) desc) as Top_3_Performers
From superstore_data
Group by Years, Sub_category
)
Select 
    Sub_category,
    Years,
    Total_Sales
From Top_Subcategory
Where Top_3_Performers IN (1,2,3);

Select * from Top_Performing_Sub_Categories_By_Years; -- Recalled the Created View, showing the table that met condition of top 3 Subcategories by Year --

#---------------------------------------------------------------------------------------------------------------------------------------------------------------#

#14--->> Calculating Top 3 Cities over the Years

Create View Top_Performing_Cities_Based_on_Year as
With Top_Cities as (
Select
	City,
    Year(Order_date_updated) as Years,
    Sum(Sales) as Total_Sales,
    Rank() Over	(partition by year(Order_date_updated) order by Sum(Sales) Desc)
    as Top_3_Performers
from superstore_data
Group by City, Years
)
Select 
Years,
City
From Top_Cities
Where Top_3_Performers IN (1,2,3);

-- Retrieving Virtually table --
Select * from Top_Performing_Cities_Based_on_Year;

#----------------------------------------------------------------------------------------------------------------------#

#15--->> Calculating Top 3 States over the Years

Create View Top_Performing_States_Based_on_Year as
With Top_Cities as (
Select
	State,
    Year(Order_date_updated) as Years,
    Sum(Sales) as Total_Sales,
    Rank() Over	(partition by year(Order_date_updated) order by Sum(Sales) Desc)
    as Top_3_Performers
from superstore_data
Group by State, Years
)
Select 
Years,
State
From Top_Cities
Where Top_3_Performers IN (1,2,3);

Select * from Top_Performing_States_Based_on_Year;

#Retrieving all three View Categories;

Select * From top_performing_sub_categories_by_years;
Select * from top_performing_cities_based_on_year;
Select * from top_performing_states_based_on_year;

#------------------------------------------Case Study Completed-------------------------------------------------------------#