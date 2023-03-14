
{% macro date_parts_a(column) -%}
     case when length({{column}}) = 4 then substring({{column}}, 3, 2)
          when length({{column}}) = 3 then substring({{column}}, 2, 2)
     end 
{%- endmacro %}