<%@ page import = "java.io.*,java.util.*,java.sql.*" %>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>

<html>
<head>
	<title>Registration Result</title>
</head>
<body>
	<% 
	/*
	Just enter the item id,quantity of components and a small description
        regarding the component and we will make sure that the component is  
        either replaced or reapired.Until either of the two occurs,the
        validity of the component would be in dispute and it would be taken
   d     own from the inventory.
	*/ 
	%>
	<h3>Add Complain</h3>
	<fieldset>
	<legend>Result</legend>
	<%	
		String item_id = request.getParameter("item_id") ;	
		String description = request.getParameter("description");
		String date_of_complain = 	request.getParameter("date_of_complain");
		String quantity = request.getParameter("quantity");
		Connection myConn = null;
		ResultSet res = null;
		Statement myStmt = null;
		try {
		//1. Get a connection to a database
		/* I don't know whether this statement is required */
		Class.forName("com.mysql.jdbc.Driver");
		
		myConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/asset", "root", "SKY15b007");
		myConn.setAutoCommit(false);
		//2.Create a statement
		myStmt = myConn.createStatement();
		if(Integer.parseInt(quantity) > 0)	{
			String query;
			query = "select item_quantity from lab_item where item_id = '" + item_id + "'";
			<% // The above query locates the item in dispute from the database %>
			res = myStmt.executeQuery(query);
			res.next();
			int item_quantity = res.getInt("item_quantity");
			int defective_quantity = Integer.parseInt(quantity);
			if(defective_quantity > item_quantity)	{
				out.println("Defective items: " + quantity + " > Items in Inventory: " + String.valueOf(item_quantity));
			}
			else {
				item_quantity -= defective_quantity;
		                <% // The item_quantity of the item is dispute is decremented by the apt value %>
				query = "update lab_item set item_quantity = " + String.valueOf(item_quantity) + " where "
						+ "item_id = '" + item_id + "'";
				myStmt.executeUpdate(query);
				
				query = "insert into complaint (item_id, description, date_of_complain, quantity) values ('" +
					item_id + "','" + description + "','" + date_of_complain + "'," + quantity + ")";
				myStmt.executeUpdate(query);
				//3.Execute a SQL query
				myConn.commit();
				out.println("Complaint added succesfully. Number of available items has been reduced.");
			}
		}
		else {
			out.println("Error: Quantity Negative or Zero.");
		}
		}
		catch(Exception e)	{
			if(myConn != null)
				myConn.rollback();
			out.println(e.getMessage());
		}
		finally {
			if(res != null && myStmt != null && myConn != null){
				res.close();
				myStmt.close();
				myConn.close();
			}
		}
		
		%>
	</fieldset>
	<br/>	
</body>
<footer>
	<br/>
	<a href="http://localhost:8080/asset_management/homepage.jsp">Homepage</a>
	<br/><br/>© 2017 <u>Akash D</u>
</footer>

</html>
