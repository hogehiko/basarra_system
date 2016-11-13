scalaVersion := "2.11.7"

assemblyJarName in assembly := "basara.jar"

assemblyOutputPath in assembly := file("src/main/processing/main/code/basara.jar")

libraryDependencies += "com.github.tototoshi" %% "scala-csv" % "1.3.4"