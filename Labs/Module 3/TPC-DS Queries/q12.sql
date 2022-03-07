--q12.sql--

SELECT TOP 100 i_item_id,
       i_item_desc,
       i_category,
       i_class,
       i_current_price,
       sum(ws_ext_sales_price) AS itemrevenue,
       sum(ws_ext_sales_price)*100/sum(sum(ws_ext_sales_price)) OVER (PARTITION BY i_class) AS revenueratio
FROM TPCDS.web_sales,
     TPCDS.item,
     TPCDS.date_dim
WHERE ws_item_sk = i_item_sk
  AND i_category IN ('Sports',
                     'Books',
                     'Home')
  AND ws_sold_date_sk = d_date_sk
  AND d_date BETWEEN cast('1999-02-22' AS date) AND (DATEADD(DAY, 30, cast('1999-02-22' AS date)))
GROUP BY i_item_id,
         i_item_desc,
         i_category,
         i_class,
         i_current_price
ORDER BY i_category,
         i_class,
         i_item_id,
         i_item_desc,
         revenueratio
OPTION (LABEL = 'q12')
		 