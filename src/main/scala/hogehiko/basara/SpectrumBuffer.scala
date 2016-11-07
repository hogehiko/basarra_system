package hogehiko.basara

import scala.collection.mutable

/**
  * Created by takehiko on 2016/11/07.
  */
class SpectrumBuffer(band:Int, bufferSize:Long) {
  val sampleQueue = mutable.Queue[Array[Float]]()

  val sum:Array[Float] = new Array[Float](band)

  def add(spectrum:Array[Float]) = {
    sampleQueue.enqueue(spectrum)
    for(i <- 0 to band-1){
      sum(i) += spectrum(i)
    }
    if(sampleQueue.size > bufferSize){
      val deleted = sampleQueue.dequeue()
      for(i<-0 to band-1)
        sum(i) -= deleted(i)

    }
  }

  def getAverageOfBuffer:Array[Float] =  sum.map(_ / bufferSize)
}
