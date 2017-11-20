<%@ page import = "java.io.*,java.util.*,java.sql.*" %>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>

<html>
<head>
	<title>Registration Result</title>
</head>
<body>
	<h3>Add Order</h3>
	<fieldset>
	<legend>Result</legend>
	<%	
		String item_id = request.getParameter("item_id") ;	
		String supplier = request.getParameter("supplier");
		String order_date = request.getParameter("order_date");
		String order_quantity = request.getParameter("order_quantity");
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
		if(Integer.parseInt(order_quantity) > 0)	{
			String query = "insert into orders (item_id, supplier, order_date, order_quantity)"
				+ " values ('" + item_id + "','" + supplier + "','"
				+ order_date + "'," + order_quantity + ")";		
			
			int i = myStmt.executeUpdate(query);
			
			query = "select item_quantity from lab_item where item_id = '" + item_id + "'";
			res = myStmt.executeQuery(query);
			res.next();
			int old_quantity = res.getInt("item_quantity");
			old_quantity += Integer.parseInt(order_quantity);
			<% 
			/*
			 Update the old_quantity by the amount recieved from the supplier.Note that only
			 those users having privilege levels 1 and 2 are authorized to add orders.(To see
			 what the privilege levels mean,refer to the documentation.).As of now,in Phase I
			 all the users are admins.
			 */
			 %>
			query = "update lab_item set item_quantity = '" + old_quantity + "' where item_id = '" + item_id + "'";
			myStmt.executeUpdate(query);
			
			myConn.commit();
			//3.Execute a SQL query
			out.println("Order added succesfully");
		}
		else {
			out.println("Error: Order Quantity Negative or Zero.");
		}
		}
		catch(Exception e)	{
			if(myConn != null)
				myConn.rollback();
		       <% // In case queries do not execute successfully. %>
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
