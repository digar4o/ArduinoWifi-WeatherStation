	// Connect to database server
	mysql_connect("HOSTNAME", "USERNAME", "PASSWORD") or die (mysql_error ());

	// Select database
	mysql_select_db("DATABASENAME") or die(mysql_error());

	// SQL query
	$strSQL = "SELECT * FROM tableName ORDER BY unixtime DESC LIMIT 1";

	// Execute the query (the recordset $rs contains the result)
	$rs = mysql_query($strSQL) or die(mysql_error());
	
	// Loop the recordset $rs
	echo '<div class="sidetitle" style="width: 200px; float: left;">';
	echo 'LIVE WEATHER';
	echo '</div>';
	
        echo '<div class="viewmore" style="float: right; width: 100px;"><a style="color: #4a7194; text-decoration: none;" href="http://dgsjournalism.co.uk/index.php?option=com_content&view=article&id=259">more info &gt;&gt;</a></div>';
	while($row = mysql_fetch_array
	($rs)) {

	   // Write the value of the column FirstName and BirthDate
	  echo '<div class="sideleftcol" style="float: left; width: 185px; height: 250px;">';
	  
	  echo "<h3><b> Temperature: </b></h1>" . $row['temp'] . " (°C)";
	  echo "<h3><b> Air Pressure: </b></h1>" . $row['pres'] . " (millibars)" . "<br />";
	  echo '</div>';
	  echo '<div class="siderightcol" style="float: right; width: 185px; height: 250px;">';
          echo "<h3><b> Humidity: </b></h1>" . $row['humi'] . ' (%)' . "<br />";
	  echo "<h3><b> Wind Speed: </b></h1>" . $row['wind'] . ' (MPH)' . "<br />";
	  echo '</div>';

	  }

	// Close the database connection
	mysql_close();



















