<%@ page import = "java.io.*,java.util.*,java.sql.*" %>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>

<html>
<body>
	<%	
		String user_id = request.getParameter("user_id") ;	
		String password = request.getParameter("password");
		try {
		//1. Get a connection to a database
		/* I don't know whether this statement is required */
		Class.forName("com.mysql.jdbc.Driver");
		
		Connection myConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/asset", "root", "SKY15b007");
		
		//2.Create a statement
		Statement myStmt = myConn.createStatement();
		
		//3.Execute a SQL query
		ResultSet res = myStmt.executeQuery("select * from user");
		String User_id, Password, User_name = null;
		int previlege;
		boolean flag = false;
		while(res.next())	{
			User_id = res.getString("user_id");
			Password = res.getString("password");
			previlege = res.getInt("previlege");
			<%
			/*
			Privilege level 1 : Professor,Assistant Professor,Head Lab Manager.
			Privilege level 2 : Lab Manager,Project Associate.
			Privilege level 3 : Teaching Assistant.
			Privilege level 4 : Student
			*/
			%>
			User_name = res.getString("user_name");
			if(user_id.equals(User_id) && password.equals(Password) && previlege == 2)	{
				flag = true;
				break;
			}
		}
	        <%
		/*
		In special cases a student might be upgraded to privilege level 3 on the orders
                of a professor but not higher. 
		*/
		%>
		if(flag)	{
			String redirect = "http://localhost:8080/asset_management/homepage.jsp?user_name=" + User_name;
			response.setStatus(response.SC_MOVED_TEMPORARILY);
			response.setHeader("Location", redirect);
		}
		else {
	%>
		<h3>---Login Info---</h3>		
		<fieldset>
		Incorrect Credentials
		<br/><br/>
		<a href="http://localhost:8080/asset_management/login.html">Try again?</a>
		</fieldset>
		
	<% 
		}
	%>
	<%	
		res.close();
		myStmt.close();
		myConn.close();
		}
		catch(Exception e)	{
			out.println(e.getMessage());
		}
		
	%>
	<br/><br/>	
</body>
<footer>
	© 2017 <u>Akash D</u>
</footer>
</html>
