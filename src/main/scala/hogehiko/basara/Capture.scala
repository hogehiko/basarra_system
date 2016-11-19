package hogehiko.basara

import java.io.File

import scala.annotation.tailrec
import scala.collection.mutable
import com.github.tototoshi.csv._


/**
  * Created by takehiko on 2016/11/06.
  */
class Capture(band:Int, bufferSize:Long, captureLogFileName:String, learningLogFileName:String) {
  val highlowFromSample = (highlow _) compose (distances _)

  val buf = new SpectrumBuffer(band, bufferSize)

  val captureLog = new File(captureLogFileName)

  def makeClassifier() = {
    val csvReader = CSVReader.open(learningLogFileName)
    val samples = for(row <- csvReader.toStream) yield {
      row match{
        case note :: bands =>
          val innote = note.substring(0,1)
          val v = bands.map(_.toFloat)
          (innote,
            highlowFromSample
            (v)
              .toVector)
      }
    }
    val m = Classifier.make(samples, notes)
    m
  }

  val csvWriter = CSVWriter.open(captureLog)
  def capture(sample:Array[Float]) :Unit = {
    buf.add(sample)
  }

  val notes = List("A", "C", "D", "E", "G")
  //val classifiers:List[(String, Classifier[String])] = for(n<-notes) yield (n, makeClassifier(n))
  val classifier = makeClassifier()
  def calc(band:Array[Float]) = {
    val peaks = getPeak(band).toVector
    classifier.calc(peaks)
  }

  def log(note:String, sample:Array[Float]) = {
    csvWriter.writeRow(note::sample.toList)
    csvWriter.flush()
  }

  def getAverage = buf.getAverageOfBuffer

  def getPeak(sample:Array[Float]):Array[Int] = highlowFromSample(sample.toList).toArray
}

object Capture extends App{
  val capture = new Capture(512, 100, "sample.log", "src/main/processing/main/ibanez.log")

}
