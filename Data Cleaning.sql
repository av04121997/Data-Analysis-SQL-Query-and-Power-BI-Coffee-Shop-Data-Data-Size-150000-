Select * from coffee_shop_data

# DESCRIBE coffee_shop_data

# Change The DATA TYPE = DATE
# Converting Transaction_date from INT to DATE formate
# USE OF UPDATE, SET, ALTER, MODIFY

SET SQL_SAFE_UPDATES = 0;

Update coffee_shop_data
SET transaction_date = STR_TO_DATE(transaction_date,'%d-%m-%Y');

ALTER table coffee_shop_data
Modify column transaction_date DATE;

# Change The DATA TYPE = TIME
# Converting Transaction_Time from INT to TIME formate

Update coffee_shop_data
SET transaction_time = str_to_date(transaction_time,'%H:%i:%s');

ALTER table coffee_shop_data
Modify column transaction_time time;

# Changing Column Name 

ALTER table coffee_shop_data
Change column transaction_id transaction_ids int       -- Existing name space New Name and Data Type
