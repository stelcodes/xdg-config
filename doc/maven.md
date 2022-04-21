https://maven.apache.org/guides/getting-started

# Make a new project
`mvn -B archetype:generate -DgroupId=stelcodes -DartifactId=ipleak-gtk`

# pom.xml
Java world loves XML. Edit the pom.xml for profit.
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>stelcodes</groupId>
  <artifactId>ipleak-gtk</artifactId>
  <packaging>jar</packaging>
  <version>1.0-SNAPSHOT</version>
  <name>ipleak-gtk</name>
  <url>http://maven.apache.org</url>
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
    <!-- This is where you add dependencies -->
    <dependency>
      <groupId>ch.bailu.java-gtk</groupId>
      <artifactId>java-gtk</artifactId>
      <version>0.1-SNAPSHOT</version>
    </dependency>
  </dependencies>
  <properties>
    <!-- This is where you set the JDK version -->
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
    <!-- This is where set your main class -->
    <exec.mainClass>stelcodes.App</exec.mainClass>
  </properties>
</project>
```

# Compile your code

`mvn compile`

# Run your main class

`mvn exec:java`

# Run tests

`mvn test`

# Create jar

`mvn package`

# Create jar and install into ~/.m2

`mvn install`
