select * 
from {{ metrics.calculate(
    metric('Gympersons'),
    grain='year'
) }}