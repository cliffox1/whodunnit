select * 
from {{ metrics.calculate(
    metric('metric_gympersons'),
    grain='year'
) }}