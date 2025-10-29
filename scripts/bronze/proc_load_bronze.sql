/*
============================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
============================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the BULK INSERT command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
============================================================
*/
create or alter procedure bronze.load_bronze As
begin 
declare @start_time datetime, @end_time datetime,@batch_start_time datetime,@batch_end_time datetime; 
begin try
set @batch_start_time=GETDATE();
print'==================================================================';
print 'Loading Broze Layer';
print'==================================================================';


print'-------------------------------------------------------------------';
print 'Loading CRM Tables';
print'-------------------------------------------------------------------';
set @start_time=GETDATE();
print '>>  Truncating Tables: [broze].[crm_cust_info]';

TRUNCATE TABLE  [broze].[crm_cust_info]
	
print '>>  Inserting Data Into: [broze].[crm_cust_info]';
BULK INSERT  [broze].[crm_cust_info]
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time=GETDATE();
print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
print'>>-------------------------------------------------------';


set @start_time=GETDATE();
print '>>  Truncating Tables: [broze].[crm_prd_info]';
TRUNCATE TABLE [bronze].[crm_prd_info]
print '>>  Inserting Data Into: [broze].[crm_prd_info]';
BULK INSERT  [bronze].[crm_prd_info]
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time=GETDATE();
print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
print'>>-------------------------------------------------------';

set @start_time=GETDATE();
print '>>  Truncating Tables: [broze].[crm_sales_details]';
TRUNCATE TABLE [bronze].[crm_sales_details]
print '>>  Inserting Data Into: [broze].[crm_sales_details]';
BULK INSERT  [bronze].[crm_sales_details]
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time=GETDATE();
print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
print'>>-------------------------------------------------------';
print'-------------------------------------------------------------------';
print 'Loading ERP Tables';
print'-------------------------------------------------------------------';



set @start_time=GETDATE();
print '>>  Truncating Tables:  [bronze].[erp_loc_a101]';
TRUNCATE TABLE  [bronze].[erp_loc_a101]
print '>>  Inserting Data Into:  [bronze].[erp_loc_a101]';
BULK INSERT  [bronze].[erp_loc_a101]
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time=GETDATE();
print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
print'>>-------------------------------------------------------';

set @start_time=GETDATE();
print '>>  Truncating Tables:  [bronze].[erp_cust_az12]';
TRUNCATE TABLE [bronze].[erp_cust_az12]
print '>>  Inserting Data Into:  [bronze].[erp_cust_az12]';
BULK INSERT [bronze].[erp_cust_az12]
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time=GETDATE();
print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
print'>>-------------------------------------------------------';


set @start_time=GETDATE();
print '>>  Truncating Tables: [bronze].[erp_px_cat_g1v2]';
TRUNCATE TABLE [bronze].[erp_px_cat_g1v2]
print '>>  Inserting Data Into:   [bronze].[erp_px_cat_g1v2]';
BULK INSERT [bronze].[erp_px_cat_g1v2]
FROM 'C:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time=GETDATE();
print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
print'>>=========================================';

set @batch_end_time=GETDATE();
print'======================================='
print ' Loading Bronze Layer is completed';
print '>>Total  Load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds';
print'======================================='

end try 
begin catch
 print'========================================='
 print'ERROR OCCURED DURING LOADING BRONZE LAYER'
 print'Error Message ' + ERROR_MESSAGE();
 print'Error Message ' + CAST(ERROR_NUMBER() AS NVARCHAR);
  print'Error Message ' + CAST(ERROR_STATE() AS NVARCHAR);
 print'========================================='
end catch
end
