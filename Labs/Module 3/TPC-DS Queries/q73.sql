--q73.sql--

SELECT c_last_name,
       c_first_name,
       c_salutation,
       c_preferred_cust_flag,
       ss_ticket_number,
       cnt
FROM
  (SELECT ss_ticket_number,
          ss_customer_sk,
          count(*) cnt
   FROM TPCDS.store_sales,
        TPCDS.date_dim,
        TPCDS.store,
        TPCDS.household_demographics
   WHERE TPCDS.store_sales.ss_sold_date_sk = TPCDS.date_dim.d_date_sk
     AND TPCDS.store_sales.ss_store_sk = TPCDS.store.s_store_sk
     AND TPCDS.store_sales.ss_hdemo_sk = TPCDS.household_demographics.hd_demo_sk
     AND TPCDS.date_dim.d_dom BETWEEN 1 AND 2
     AND (TPCDS.household_demographics.hd_buy_potential = '>10000'
          OR TPCDS.household_demographics.hd_buy_potential = 'unknown')
     AND TPCDS.household_demographics.hd_vehicle_count > 0
     AND CASE
             WHEN TPCDS.household_demographics.hd_vehicle_count > 0 THEN TPCDS.household_demographics.hd_dep_count/ TPCDS.household_demographics.hd_vehicle_count
             ELSE NULL
         END > 1
     AND TPCDS.date_dim.d_year IN (1999,
                                   1999+1,
                                   1999+2)
     AND TPCDS.store.s_county IN ('Williamson County',
                                  'Franklin Parish',
                                  'Bronx County',
                                  'Orange County')
   GROUP BY ss_ticket_number,
            ss_customer_sk) dj,
     TPCDS.customer
WHERE ss_customer_sk = c_customer_sk
  AND cnt BETWEEN 1 AND 5
ORDER BY cnt DESC,
         c_last_name ASC
OPTION (LABEL = 'q73')