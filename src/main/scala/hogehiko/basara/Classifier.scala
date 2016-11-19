package hogehiko.basara

import scala.collection.mutable

/**
  * Created by takehiko on 2016/11/13.
  * すべて2クラス分類にしてみる？
  */
class Classifier[T](sample:Seq[(T, Vector[Int])], classes:List[T]) {
  val variables:List[Variable] = List.fill(sample(0)._2.size){new Variable}

  def build(_sample:Seq[(T, Vector[Int])]): Unit ={
    _sample match{
      case Nil => ()
      case head #:: tail => {
        _applySample(head._1, (variables zip head._2).toList)
        build(tail)
      }
    }
  }

  type Label = Int

  type Clazz = T

  def count(c:Clazz):Int = variables.map(_.count(c)).sum

  def p(c:Clazz) = (count(c):Double) / numRecords

  def _applySample(c:Clazz, records:List[(Variable, Label)]):Unit = {
    records match{
      case Nil => ()
      case (v:Variable, i:Label) :: tail => {
        v.incr(c,i)
        _applySample(c, tail)
      }
    }
  }

  class Variable{
    val counter = mutable.Map[(Clazz, Label), Int]()

    def incr(c:Clazz, l:Label) = {
      if(counter.contains(c,l)){
        counter(c,l) += 1
      }else{
        counter += (c,l) -> 1
      }
    }

    def p(c:Clazz, l:Label):Double = 0.0001 + (count(c, l):Double) / count(c)

    def count(c:Clazz, l:Label) = counter.get(c,l).getOrElse(0)

    def count(c:Clazz) = (0 /: (for(((_c, l), v)<-counter if(c==_c))yield v))(_ + _)
  }

  def likelihood(c:T, sample:Vector[Int]) = (Math.log(p(c)) /: (for((l,v)<-(sample zip variables))yield Math.log(v.p(c,l)))){_+_}

  def calc(sample:Vector[Int]) = {
//    val ok = likelihood(true, sample);
//    val ng = likelihood(false, sample);
    val likelihoods = for(c<-classes)yield (c, likelihood(c, sample))
    likelihoods.maxBy(_._2)._1
  }

  //def posterior(clazz:Boolean, l:Label) = count(clazz, l) / numRecords

  def count(clazz:Clazz,  l:Label):Int =variables.map(_.count(clazz, l)).sum

  def numRecords:Int = sample.length + 1

  build(sample)
}

object Classifier{
  def make[T](sample:Seq[(T, Vector[Int])], classes:List[T]) = new Classifier[T](sample, classes)
}