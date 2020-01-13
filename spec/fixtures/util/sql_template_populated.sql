SELECT email,
    username
FROM my_database.customers
WHERE customer_id IN ( ID_STRINGS )
GROUP BY location
ORDER BY username
