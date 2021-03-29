<%@ page contentType="text/html; charset=utf-8" errorPage="" %>
<%@ page import="java.sql.*"%>
<HTML>
<head>
</head>
<body>
    <%
    Connection con;
    Statement sql;
    ResultSet rs;
    try{  Class.forName("com.mysql.cj.jdbc.Driver");
    }
    catch(Exception e){
       out.println("忘记把MySQL数据库的JDBC-数据库驱动程序复制到JDK的扩展目录中");
   }
try { String uri= "jdbc:mysql://localhost:3306/lab"+ "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
          String user="root";
          String password="123123";
con=DriverManager.getConnection(uri,user,password);
          sql=con.createStatement();
          String username1 = request.getParameter("username");
          String password1 = request.getParameter("password");
          String s="select * from admin where Id=" +"'"+ username1 +"'";
          rs=sql.executeQuery(s);
          while(rs.next()){
            if(rs!=null && rs.getString(2).equals(password1)){
              session.setAttribute("username",username1);
              session.setAttribute("is_out","0");
              out.println("登陆成功,正在加载，请稍后。");
              response.setHeader("refresh","url = ../Main/Admin/Main.jsp");
              %>
<script language =javascript>window.open('../Main/Admin/Main.jsp','_top')</script>
          <%}else{
            session.setAttribute("user",null);
            session.setAttribute("password",null);
            out.println("账号错误，请重新输入.正在退回登陆界面");
            response.setHeader("refresh","5;url = login.jsp");
          }
    }
    con.close();
  }
    catch(SQLException e){
        out.print(e);}
    %>

</body></HTML>
