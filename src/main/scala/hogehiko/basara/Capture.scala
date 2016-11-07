package hogehiko.basara

import scala.annotation.tailrec

/**
  * Created by takehiko on 2016/11/06.
  */
class Capture {
  def capture(sample:Array[Float]) :Unit = {
    println(distances(sample.toList)(10))
  }

  def getPeak(sample:Array[Float]):Array[Int] = highlowFromSample(sample.toList).toArray

  val highlowFromSample = (highlow _) compose (distances _)

  def distances(sample:List[Float]):List[Float] = {
    @tailrec
    def _distance(sample:List[Float], conv:List[Float]):List[Float] = {
      sample match {
        case first :: second :: tail =>_distance(second :: tail,  (second / first) :: conv)
        case first :: Nil => conv
        case Nil => conv
      }
    }
    _distance(sample, List()).reverse
  }
  val UP = 1;
  val UPPER_PEAK = 2;
  val DOWN = 3;
  val DOWNER_PEAK = 4;

  def highlow(sample:List[Float]):List[Int] = {
    val INCREASE = 1;
    val DECREASE = -1;
    val updown = sample.map(x=>if(x>1)INCREASE else DECREASE)

    def state(current:Int, next:Int) = (current, next) match{
      case (`INCREASE`, `INCREASE`) => UP
      case (`INCREASE`, `DECREASE`) => UPPER_PEAK
      case (`DECREASE`, `DECREASE`) => DOWN
      case (`DECREASE`, `INCREASE`) => DOWNER_PEAK
    }
    @tailrec
    def _highlow(sample:List[Int],result:List[Int]):List[Int]={
      sample match{
        case current :: next :: tail => _highlow(next :: tail, state(current, next) :: result)
        case current :: Nil if (current==INCREASE) => UP :: result
        case current :: Nil if (current==DECREASE) => DOWN :: result
        case Nil => result
      }
    }
    _highlow(updown, List()).reverse
  }
}
