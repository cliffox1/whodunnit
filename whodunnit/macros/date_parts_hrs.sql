{% macro date_parts_hrs(column) -%}
    case when length({{column}}) = 4 then substring({{column}}, 1, 2)
         when length({{column}}) = 3 then '0' || substring({{column}}, 1, 1)
    end 
{%- endmacro %}