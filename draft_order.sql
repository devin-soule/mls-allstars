with lotto as (
    select generate_series(1,12) season_rank,
           unnest(array['Tom', 'Brian', 'Devin', 'Rolly', 'Jared', 'Will', 'Dan', 'Andy', 'Edward', 'Steve', 'Martin', 'xxx']) owner,
           unnest(array[1,2,4,3,6,5,9,9,9,9,9,10]) balls
  )
select row_number() over (order by draw.luck desc) pick_no,
       lotto.owner,
       lotto.season_rank,
       lotto.balls,
       draw.lucky_ball_no,
       draw.luck
from lotto
  join lateral (
    select t1.ball_no lucky_ball_no,
           t1.luck
    from (
        select generate_series(1, lotto.balls) ball_no,
               random() luck
      ) t1
    order by t1.luck desc limit 1
  ) draw on true
order by pick_no
