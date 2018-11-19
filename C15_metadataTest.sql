# 第15章 元数据 

use test;

##### 15.1 关于数据的数据  

##### 15.2 信息模式  
SELECT 
    table_name, table_type
FROM
    information_schema.tables
WHERE
    table_schema = 'bank'
ORDER BY 1;

SELECT 
    table_name, table_type
FROM
    information_schema.tables
WHERE
    table_schema = 'bank'
        AND table_type = 'BASE TABLE'
ORDER BY 1;

SELECT 
    table_name, is_updatable
FROM
    information_schema.views
WHERE
    table_schema = 'bank'
ORDER BY 1;

SELECT 
    column_name,
    data_type,
    character_maximum_length char_max_len,
    numeric_precision num_prcsn,
    numeric_scale num_scale
FROM
    information_schema.columns
WHERE
    table_schema = 'bank'
        AND table_name = 'account'
ORDER BY ordinal_position;

SELECT 
    index_name, non_unique, seq_in_index, column_name
FROM
    information_schema.statistics
WHERE
    table_schema = 'bank'
        AND table_name = 'account'
ORDER BY 1 , 3;

SELECT 
    constraint_name, table_name, constraint_type
FROM
    information_schema.table_constraints
WHERE
    table_schema = 'bank'
ORDER BY 3 , 1;

##### 15.3 使用元数据 

#### 15.3.1 模式生成脚本 

#### 15.3.2 部署验证 

#### 15.3.3 生成动态SQL  

########################################## test



