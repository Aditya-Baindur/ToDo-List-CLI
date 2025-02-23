-- This will create a table name tasks which you need to ONLY pass in the message parameter.
-- PS, this is POSTGRES SQL SPECIFIC CODE. 
-- You can use this code to also connect your local postgres server to the CLI application.

CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

select * from tasks; -- This should not return anything and is only here for you to see the data once the table is created and stuff is in it. 