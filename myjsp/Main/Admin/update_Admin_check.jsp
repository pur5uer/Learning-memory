<%@ page contentType="text/html; charset=utf-8" errorPage="" %>
<%@ page import="java.sql.*"%>
<html>
    <body>
    <%
        String name = (String)session.getAttribute("username");
        String is_out = (String)session.getAttribute("is_out");
        if((is_out == null || is_out.equals("0")) && name == null){
            out.print("<script>alert('请先登录');</script>");
            response.setHeader("refresh","1;url = ../default/Main.jsp");
        }
        
        Connection con;
        Statement sql;
        ResultSet rs;
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
        }
        catch(Exception e){
            out.print(e);
        }
        try{
            String uri = "jdbc:mysql://localhost:3306/Lab" + 
            "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            String user = "root";
            String password = "123123";
            con = DriverManager.getConnection(uri,user,password);
            sql = con.createStatement();
            String username1 = request.getParameter("username");
            String password1 = request.getParameter("password");
            String newPassword1 = request.getParameter("newPassword");
            String passwordCheck1 = request.getParameter("passwordCheck");
            String s="select * from admin where Id=" +"'"+ username1 +"'";
            rs = sql.executeQuery(s);
            if(rs == null){
                out.println("账号不存在，请重新输入.正在退回账号修改界面");
                response.setHeader("refresh","3;url = update_Admin.jsp");
            }
            else{
                if(rs.next()){
                    if(!rs.getString(2).equals(password1)){
                        out.println("密码错误，请重新输入.正在退回账号修改界面");
                        response.setHeader("refresh","3;url = update_Admin.jsp");
                    }
                    else{
                        if(!newPassword1.equals(passwordCheck1)){
                            out.println("两次输入的新密码不一致，请重新输入.正在退回账号修改界面");
                            response.setHeader("refresh","3;url = update_Admin.jsp");
                        }
                        else{
                            String s1 = "update Admin set Password = " + "'" + newPassword1 +
                            "'" + "where Id = " + username1;
                            sql.executeUpdate(s1);
                            out.println("修改密码成功，您的新密码为" + newPassword1 + "，请牢记." + "<br>");
                            out.println("请在左侧选择功能." + "<br>");
                        }
                    }
                }
            }
            con.close();
        }
            catch(SQLException e){
                out.println(e);
            }
        %>
    </body>
</html>